//
//  MBDebugCircularQueue.m
//  MBDebug
//
//  Created by Lizhao on 2023/8/1.
//

#import "MBDebugMonitorLogQueue.h"

@interface MBDebugMonitorLogQueue() {
    NSMutableArray *_array;
    NSInteger _front;
    NSInteger _tail;
}

@property (nonatomic, assign) NSInteger capacity;

@end

@implementation MBDebugMonitorLogQueue

+ (nonnull instancetype)loopQueueWithCapacity:(NSUInteger)capacity {
    return [[MBDebugMonitorLogQueue alloc] initWithCapacity:capacity];
}


- (instancetype)initWithCapacity:(NSInteger)capacity {
    self = [super init];
    if (self) {
        _capacity = capacity;
        _size = 0;
        _errorObjectCount = 0;
        _array = [NSMutableArray arrayWithCapacity:capacity];
        for (NSInteger i = 0; i < capacity; i++) {
            [_array addObject:@(0.0f)];
        }
        _front = 0;
        _tail = 0;
    }
    return self;
}

- (void)enqueue:(id<MBDebugMonitorLogObject>)value {
    if (_size == _capacity) {
        [self dequeue];
    }
    _array[_tail] = value;
    _tail = (_tail + 1) % _capacity;
    _size++;
    if([value respondsToSelector:@selector(isErrorObject)] && [value isErrorObject]){
        _errorObjectCount++;
    }
}

- (void)removeObjects:(NSArray<id<MBDebugMonitorLogObject>> *)objects {
    NSInteger originalSize = self.size;
    for (NSInteger i = 0; i < originalSize; i++) {
        id<MBDebugMonitorLogObject> object = [self dequeue];
        if (![objects containsObject:object]) {
            [self enqueue:object];
        }
    }
}

- (id<MBDebugMonitorLogObject>)dequeue {
    if ([self isEmpty]) {
        return nil;
    }
    id<MBDebugMonitorLogObject> obj = _array[_front];
    _array[_front] = @(0.0f);
    _front = (_front + 1) % _capacity;
    _size--;
    if([obj respondsToSelector:@selector(isErrorObject)] && [obj isErrorObject]){
        _errorObjectCount--;
    }
    return obj;
}

- (NSArray<id<MBDebugMonitorLogObject>> *)allLogObjects {
    NSMutableArray *allItems = [NSMutableArray new];
    if([self isEmpty]){
        return allItems.copy;
    }
    @try {
        if (_front < _tail) {
            [allItems addObjectsFromArray:[_array subarrayWithRange:NSMakeRange(_front, _tail - _front)]];
        } else {
            [allItems addObjectsFromArray:[_array subarrayWithRange:NSMakeRange(_front, _capacity - _front)]];
            [allItems addObjectsFromArray:[_array subarrayWithRange:NSMakeRange(0, _tail)]];
        }
    } @catch  (NSException *exception) {
    } @finally {
    }
    
    return allItems;
}

- (NSArray<id<MBDebugMonitorLogObject>> *)allErrorObjects {
    if(_errorObjectCount == 0){
        return @[];
    }
    NSMutableArray<id<MBDebugMonitorLogObject>> *allObjects = [self allLogObjects].mutableCopy;
    NSMutableArray *arr = @[].mutableCopy;
    for(id<MBDebugMonitorLogObject>object in allObjects){
        if([object respondsToSelector:@selector(isErrorObject)] && [object isErrorObject]){
            [arr addObject:object];
        }
    }
    return arr;
}

- (void)clear {
    [_array removeAllObjects];
    _front = 0;
    _tail = 0;
    _size = 0;
    _errorObjectCount = 0;
}

- (BOOL)isEmpty {
    return (_size == 0);
}

@end
