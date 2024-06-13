//
//  MBAPMDataCacheQueue.m
//  MBAPMLib
//
//  Created by xp on 2020/8/14.
//

#import "MBAPMDataCacheQueue.h"

@interface MBAPMDataCacheQueue() {
    NSMutableArray *_array;
    NSInteger _front, _tail;
    NSInteger _size;
    NSLock *_arrayLock;
}

@property (nonatomic, assign) NSInteger capacity;


@end

@implementation MBAPMDataCacheQueue

- (instancetype)initWithCapacity:(NSInteger)capacity {
    if(self = [super init]) {
        _capacity = capacity;
        _front = 0;
        _tail = 0;
        _size = 0;
        _arrayLock = [[NSLock alloc] init];
        [self initArray];
    }
    return self;
}

- (void)initArray {
    _array = [NSMutableArray new];
    for(int i = 0; i < _capacity; i++) {
        [_array addObject:@(0.0f)];
    }
}

+ (instancetype)loopQueueWithCapacity:(NSUInteger)capacity {
    return [[MBAPMDataCacheQueue alloc]initWithCapacity:capacity];
}

- (void)enqueue:(CGFloat)value {
    if(_size == self.capacity) {
        [self dequeue];
    }
    [_arrayLock lock];
    _array[_tail] = @(value);
    _tail = (_tail + 1)%self.capacity;
    _size++;
    [_arrayLock unlock];
}

- (id)dequeue {
    if([self isEmpty]) {
        return nil;
    }
    [_arrayLock lock];
    id obj = _array[_front];
    _array[_front] = @(0.0f);
    if (_size == 0) {
        _front = 0;
        return obj;
    }
    _front = (_front + 1)%_size;
    _size--;
    [_arrayLock unlock];
    return obj;
}

- (NSArray *)getAllItems {
    NSMutableArray *allItems = [NSMutableArray new];
    @try {
        if(_front < _tail) {
            [_arrayLock lock];
            [allItems addObjectsFromArray:[[NSArray alloc] initWithArray:[_array subarrayWithRange:NSMakeRange(_front, _tail - _front)] copyItems:YES]];
            [_arrayLock unlock];
        } else {
            [_arrayLock lock];
            [allItems addObjectsFromArray:[[NSArray alloc] initWithArray:[_array subarrayWithRange:NSMakeRange(_front, _size  - _front)] copyItems:YES]];
            [allItems addObjectsFromArray:[[NSArray alloc] initWithArray:[_array subarrayWithRange:NSMakeRange(0, _tail)] copyItems:YES]];
            [_arrayLock unlock];
        }
    } @catch (NSException *exception) {
    } @finally {
    }
    return allItems;
}

- (NSArray *)getLatestItemsForCount:(NSInteger)count {
    NSMutableArray *latestItems = [NSMutableArray new];
    
    // 保证不要尝试获取超过数组实际大小的数据
    NSInteger itemsToFetch = MIN(count, _size);
    
    [_arrayLock lock];
    for (NSInteger i = 0; i < itemsToFetch; i++) {
        NSInteger index = (_tail - 1 - i + self.capacity) % self.capacity;
        [latestItems insertObject:_array[index] atIndex:0];
    }
    [_arrayLock unlock];
    
    return latestItems;
}

- (void)clear {
    [_arrayLock lock];
    [_array removeAllObjects];
    _front = 0;
    _tail = 0;
    _size = 0;
    [_arrayLock unlock];
}

#pragma mark - Private Method
- (BOOL)isEmpty {
    return (_size == 0);
}

@end
