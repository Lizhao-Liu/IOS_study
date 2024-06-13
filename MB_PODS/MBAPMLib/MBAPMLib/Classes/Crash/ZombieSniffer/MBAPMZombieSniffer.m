//
//  MBAPMZombieSniffer.m
//  MBAPMLib
//
//  Created by xp on 2022/10/19.
//

@import MBFoundation;
#import "MBAPMZombieSniffer.h"
#import "MBAPMZombieProxy.h"
#import "MBAPMCallStackUtil.h"
#import "MBAPMFIFOQueue.h"
#import "MBAPMLogDef.h"
#import <malloc/malloc.h>
#import <objc/runtime.h>
#import <os/lock.h>


typedef void (*MBDeallocPointer) (id obj); // 对象销毁block

static uint32_t  kEstimateZombieObjectSize = 64; //估算对象平均大小64Byte
static uint32_t  kEstimateDeallocStackSize = 240; //估算堆栈平均大小 30 * 8 = 240Byte

static BOOL _enabled = NO; //是否已启动僵尸对象检测
static BOOL _crashedWhenDetectZombie = NO; // 是否在访问僵尸对象时触发崩溃
static BOOL _traceDeallocStack = NO; // 是否抓取对象dealloc堆栈
static NSUInteger _maxOccupyMemorySize = 10 * 1024 * 1024; // 保存释放对象和堆栈，最大内存占用
static NSUInteger _currentOccupyMemorySize = 0; // 当前保存释放对象和堆栈占用内存大小
static MBAPMZombieDetectStrategy _detectStrategy = MBAPMZombieDetectStrategyCustomObjectOnly; // 当前设置的检测模式,默认为只监控自定义对象
struct MBAPMFIFOQueue *_delayFreeQueue; // 延迟释放队列

static NSArray *_rootClasses = nil; // 需要进行hook的根类

static NSDictionary<id, NSValue *> *_rootClassDeallocImps = nil; // 保存被hook类的dealloc方法的函数指针

os_unfair_lock _stackManagerLock; // 堆栈记录读写锁


/// 白名单
static NSMutableSet *__mb_sniff_white_list() {
    static NSMutableSet *mb_sniff_white_list    ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mb_sniff_white_list = [[NSMutableSet alloc] init];
    });
    return mb_sniff_white_list;
}


/// 黑名单
static NSMutableSet *__mb_sniff_black_list() {
    static NSMutableSet *mb_sniff_black_list;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mb_sniff_black_list = [[NSMutableSet alloc] init];
    });
    return mb_sniff_black_list;
}


/// 获取自定义类列表
static NSSet *__mb_sniff_main_bundle_class_list() {
    static NSMutableSet *mb_main_bundle_class_list;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unsigned int classCount=0;
        const char** classNames=objc_copyClassNamesForImage([[NSBundle mainBundle] executablePath].UTF8String,&classCount);
        if (classNames) {
            mb_main_bundle_class_list = [NSMutableSet new];
            for (unsigned int i = 0; i < classCount; i++) {
                const char *classNameChars = classNames[i];
                NSString *className = [NSString stringWithCString:classNameChars encoding:NSUTF8StringEncoding];
                [className retain];
                [mb_main_bundle_class_list addObject:className];
            }
            free(classNames);
        }
    });
    return mb_main_bundle_class_list;
}


/// 销毁对象，调用原dealloc方法进行销毁
/// @param obj 待销毁对象
static inline void __mb_dealloc(__unsafe_unretained id obj) {
    Class currentCls = [obj class];
    Class rootCls = currentCls;
    
    while (rootCls != [NSObject class] && rootCls != [NSProxy class]) {
        rootCls = class_getSuperclass(rootCls);
    }
    NSString *clsName = NSStringFromClass(rootCls);
    MBDeallocPointer deallocImp = NULL;
    [[_rootClassDeallocImps objectForKey: clsName] getValue: &deallocImp];
    
    if (deallocImp != NULL) {
        deallocImp(obj);
    }
}


/// 方法交换
/// @param method  需要交换的方法
/// @param block  调用原方式时回调block
static inline IMP __mb_swizzleMethodWithBlock(Method method, void *block) {
    IMP blockImplementation = imp_implementationWithBlock(block);
    return method_setImplementation(method, blockImplementation);
}


@implementation MBAPMZombieSniffer


+ (void)initialize {
    _rootClasses = [@[[NSObject class], [NSProxy class]] retain];
    _deallocStacks = [[NSMutableDictionary alloc]init];
    _stackManagerLock = OS_UNFAIR_LOCK_INIT;
}


#pragma mark - Public

+ (void)startSniffer:(MBAPMZombieConfig *)zombieConfig {
    @synchronized (self) {
        if (zombieConfig) {
            _crashedWhenDetectZombie = zombieConfig.crashedWhenDetectZombie;
            _traceDeallocStack = zombieConfig.traceDeallocStack;
            _detectStrategy = zombieConfig.detectStrategy;
            _maxOccupyMemorySize = zombieConfig.maxOccupyMemorySize;
            [self appendWhiteClassNameList:zombieConfig.whiteList];
            [self appendBlackClassNameList:zombieConfig.blackList];
        }
        MBAPMLogInfo(@"start zombie monitor crashedWhenDetectZombie = %d, traceDeallocStack = %d, detectStrategy = %lu, maxOccupyMemorySize = %lu", _crashedWhenDetectZombie, _traceDeallocStack, _detectStrategy, _maxOccupyMemorySize);
        [self startSwizzleDealloc];
        int32_t itemEstimateSize = kEstimateZombieObjectSize;
        if (_traceDeallocStack) {
            itemEstimateSize += kEstimateDeallocStackSize;
        }
        int32_t queueCapacity = (int32_t)(_maxOccupyMemorySize / itemEstimateSize + 1023) / 1024 * 1024;
        _delayFreeQueue = mbapm_fifo_queue_create(queueCapacity);
        [self startSwizzleDealloc];
    }
}


+ (void)startSwizzleDealloc {
    @synchronized(self) {
        if (!_enabled) {
            [self _swizzleDealloc];
            _enabled = YES;
        }
    }
}

+ (void)stopSniffer {
    @synchronized (self) {
        [self stopSwizzleDealloc];
        void * item = mbapm_fifo_queue_try_get(_delayFreeQueue);
        while (item) {
            [self freeZombieObject:item];
            item = mbapm_fifo_queue_try_get(_delayFreeQueue);
        }
        mbapm_fifo_queue_close(_delayFreeQueue);
        mbapm_fifo_queue_free(_delayFreeQueue);
        _delayFreeQueue = NULL;
        [self clearStacks];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}



+ (BOOL)traceDeallocStackEnabled {
    return _traceDeallocStack;
}

+ (void)enableTraceDeallocStack:(BOOL)enable {
    _traceDeallocStack = enable;
}

+ (void)stopSwizzleDealloc {
    @synchronized(self) {
        if (_enabled) {
            [self _unswizzleDealloc];
            _enabled = NO;
        }
    }
}

+ (void)appendWhiteClassNameList:(NSArray<NSString *> *)classNameArray {
    @synchronized(self) {
        NSMutableSet *whiteList = __mb_sniff_white_list();
        for(NSString *className in classNameArray) {
            Class whiteClass = NSClassFromString(className);
            if (whiteClass) {
                [whiteList addObject: whiteClass];
            }
        }
    }
}

+ (void)appendBlackClassNameList:(NSArray<NSString *> *)classNameArray {
    @synchronized(self) {
        NSMutableSet *blackList = __mb_sniff_black_list();
        for(NSString *className in classNameArray) {
            Class blackClass = NSClassFromString(className);
            [blackList addObject: blackClass];
        }
    }
}

+ (void)deallocStack:(KSStackCursor *)cursor ForObj:(uintptr_t)objAddress {
    MBAPMThreadStack *stack =  [self getDeallocStack:objAddress];
    if (stack) {
        [MBAPMCallStackUtil selfThreadStackByMatrix:cursor withReturnAddresses:stack.returnAddresses];
        return;
    }
    return;
}

#pragma mark - Private
+ (void)_swizzleDealloc {
    MBAPMLogInfo(@"_swizzleDealloc");
    static void *swizzledDeallocBlock = NULL;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzledDeallocBlock = [^void(id obj) {
            Class currentClass = [obj class];
            if (![self shouldDetectByClass:currentClass]) {
                __mb_dealloc(obj);
                return;
            } else {
                void *objPoint = (__bridge void *)(obj);
                size_t objMemSize = malloc_size(objPoint);
                if (objMemSize < [MBAPMZombieProxy zombieInstanceSize]) {
                    /// 僵尸代理对象所占空间大于原对象空间，无法进行覆盖
                    __mb_dealloc(objPoint);
                    return;
                }
                objc_destructInstance(obj);
                uintptr_t objAddress = (uintptr_t)objPoint;
//                MBAPMDebug(@"hook dealloc method obj = %ld", objAddress);
                size_t objMemorySize = malloc_size(objPoint);
                object_setClass(obj, [MBAPMZombieProxy class]);
                ((MBAPMZombieProxy *)obj).originClass = currentClass;
                ((MBAPMZombieProxy *)obj).throwExceptionWhenDetectZombie = _crashedWhenDetectZombie;
                ((MBAPMZombieProxy *)obj).reportDeallocStack = _traceDeallocStack;
                if (_traceDeallocStack) {
                    MBAPMThreadStack *threadStack = [MBAPMThreadStack new];
                    [MBAPMCallStackUtil selfThreadStackReturnAddresses:threadStack];
                    size_t stackMemorySize = [threadStack occupyMemorySize];
                    objMemorySize += stackMemorySize;
                    [self addDeallocStack:threadStack withObjAddress:objAddress];
                }
                
                [self freeMemoryIfNeed];

                __sync_fetch_and_add(&_currentOccupyMemorySize, (int)objMemorySize);
                void *item = mbapm_fifo_queue_put_pop_first_item_if_need(_delayFreeQueue, objPoint);
                if (item) {
                    [self freeZombieObject:item];
                }
            }
        } copy];
    });
    NSMutableDictionary *deallocImps = [NSMutableDictionary dictionary];
    for (Class rootClass in _rootClasses) {
        IMP originalDeallocImp = __mb_swizzleMethodWithBlock(class_getInstanceMethod(rootClass, @selector(dealloc)), swizzledDeallocBlock);
        [deallocImps setObject: [NSValue valueWithBytes: &originalDeallocImp objCType: @encode(typeof(IMP))] forKey: NSStringFromClass(rootClass)];
    }
    _rootClassDeallocImps = [deallocImps copy];
}

+ (void)_unswizzleDealloc {
    [_rootClasses enumerateObjectsUsingBlock:^(Class rootClass, NSUInteger idx, BOOL *stop) {
        IMP originalDeallocImp = NULL;
        NSString *clsName = NSStringFromClass(rootClass);
        [[_rootClassDeallocImps objectForKey: clsName] getValue: &originalDeallocImp];
        
        NSParameterAssert(originalDeallocImp);
        method_setImplementation(class_getInstanceMethod(rootClass, @selector(dealloc)), originalDeallocImp);
    }];
    
    [_rootClassDeallocImps release];
    _rootClassDeallocImps = nil;
}


/// 判断是否需要将即将释放对象转化为僵尸对象
/// 1. 当前类为黑名单中的类，及其子类则不需要转化；
/// 2. 策略中包含自定义类策略则判断类名是否在自定义类列表中，不判断子类；
/// 3. 策略中包含白名单策略则判断当前类是否在白名单类及其子类中；
/// 4. 策略为所有类均需要转化
+ (BOOL)shouldDetectByClass:(Class)cls {
    if (!cls) {
        return NO;
    }
    NSMutableSet<NSString *> *blackList = __mb_sniff_black_list();
    if (blackList) {
        for(Class blackClass in blackList) {
            if ([cls isSubclassOfClass:blackClass]) {
                return NO;
            }
        }
    }
    if ((_detectStrategy & MBAPMZombieDetectStrategyCustomObjectOnly) == MBAPMZombieDetectStrategyCustomObjectOnly) {
        NSString *className = NSStringFromClass(cls);
        if ([__mb_sniff_main_bundle_class_list() containsObject:className]) {
            return YES;
        }
    }
    if ((_detectStrategy & MBAPMZombieDetectStrategyWhiteList) == MBAPMZombieDetectStrategyWhiteList) {
        NSMutableSet<NSString *> *whiteList = __mb_sniff_white_list();
        if (whiteList) {
            for(Class whiteClass in whiteList) {
                if ([cls isSubclassOfClass:whiteClass]) {
                    return YES;
                }
            }
        }
    }
    if ((_detectStrategy & MBAPMZombieDetectStrategyAll) == MBAPMZombieDetectStrategyAll) {
        return YES;
    }
    return NO;
}


#pragma mark - dealloc object queue

+ (void)freeZombieObject:(void*)obj {
    uintptr_t objAddress = (uintptr_t)obj;
    size_t threadStackMemSize = 0;
    MBAPMThreadStack *threadStack = [self getDeallocStack:objAddress];
    threadStackMemSize = [threadStack occupyMemorySize];
    if (threadStack) {
        [self removeDeallocStack:objAddress];
        [threadStack release];
    }
    size_t zombieObjectSize = malloc_size(obj);
    size_t total_size = threadStackMemSize + zombieObjectSize;
    free(obj);
    __sync_fetch_and_sub(&_currentOccupyMemorySize, (int)(total_size));
}
    
+ (void)freeMemoryIfNeed {
    if (_currentOccupyMemorySize < _maxOccupyMemorySize) {
        return;
    }
    @synchronized(self) {
        if (_currentOccupyMemorySize >= _maxOccupyMemorySize) {
            [self forceFreeMemory];
        }
    }
}

+ (void)forceFreeMemory {
    uint32_t freeCount = 0;
    int max_free_count_one_time = mbapm_fifo_queue_length(_delayFreeQueue) / 5;
    void * item = mbapm_fifo_queue_try_get(_delayFreeQueue);
    while (item && freeCount < max_free_count_one_time) {
        [self freeZombieObject:item];
        item = mbapm_fifo_queue_try_get(_delayFreeQueue);
        ++freeCount;
    }
}

- (void)memoryWarningNotificationHandle:(NSNotification*)notification {
    [MBAPMZombieSniffer forceFreeMemory];
}


#pragma mark - Stack Manager
static NSMutableDictionary<NSNumber *,  MBAPMThreadStack *> *_deallocStacks = nil;

+ (void)addDeallocStack:(MBAPMThreadStack *)deallocStack withObjAddress:(uintptr_t)objAddress {
    os_unfair_lock_lock(&_stackManagerLock);
    if (deallocStack && deallocStack != 0x0) {
        [_deallocStacks setObject:deallocStack forKey:@(objAddress)];
    }
    os_unfair_lock_unlock(&_stackManagerLock);
}

+ (void)removeDeallocStack:(uintptr_t)objAddress {
    os_unfair_lock_lock(&_stackManagerLock);
    if (objAddress) {
        [_deallocStacks removeObjectForKey:@(objAddress)];
    }
    os_unfair_lock_unlock(&_stackManagerLock);
}

+ (void)clearStacks {
    os_unfair_lock_lock(&_stackManagerLock);
    [_deallocStacks removeAllObjects];
    os_unfair_lock_unlock(&_stackManagerLock);
}

+ (MBAPMThreadStack *)getDeallocStack:(uintptr_t)objAddress {
    os_unfair_lock_lock(&_stackManagerLock);
    MBAPMThreadStack *deallocStack = [_deallocStacks objectForKey:@(objAddress)];
    os_unfair_lock_unlock(&_stackManagerLock);
    return deallocStack;
}

@end
