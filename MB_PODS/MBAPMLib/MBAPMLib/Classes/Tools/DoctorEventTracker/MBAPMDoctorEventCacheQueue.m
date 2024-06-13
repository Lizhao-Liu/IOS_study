//
//  MBAPMDoctorEventCacheQueue.m
//  MBAPMLib
//
//  Created by Lizhao on 2024/2/22.
//

#import "MBAPMDoctorEventCacheQueue.h"


@interface MBAPMDoctorEventCacheQueue () {
    NSMutableArray *_array;
    NSInteger _front, _tail;
    NSInteger _size;
    NSLock *_arrayLock;
}

@property (nonatomic, assign) NSInteger capacity;

@end

@implementation MBAPMDoctorEventCacheQueue

+ (instancetype)loopQueueWithCapacity:(NSUInteger)capacity {
    return [[MBAPMDoctorEventCacheQueue alloc] initWithCapacity:capacity];
}

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
        [_array addObject:[MBAPMDoctorEventModel new]];
    }
}

- (void)enqueue:(MBAPMDoctorEventModel *)model {
    if(_size == self.capacity) {
        [self dequeue];
    }
    [_arrayLock lock];
    _array[_tail] = model;
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
    _array[_front] = [MBAPMDoctorEventModel new];
    if (_size == 0) {
        _front = 0;
        return obj;
    }
    _front = (_front + 1)%_size;
    _size--;
    [_arrayLock unlock];
    return obj;
}

- (BOOL)isEmpty {
    return (_size == 0);
}

- (void)clear {
    [_arrayLock lock];
    [_array removeAllObjects];
    _front = 0;
    _tail = 0;
    _size = 0;
    [_arrayLock unlock];
}


- (NSArray *)getAllEvents {
    NSMutableArray *allItems = [NSMutableArray new];
    @try {
        if(_front < _tail) {
            [_arrayLock lock];
            [allItems addObjectsFromArray:[_array subarrayWithRange:NSMakeRange(_front, _tail - _front)]];
            [_arrayLock unlock];
        } else {
            [_arrayLock lock];
            [allItems addObjectsFromArray:[_array subarrayWithRange:NSMakeRange(_front, _size  - _front)]];
            [allItems addObjectsFromArray:[_array subarrayWithRange:NSMakeRange(0, _tail)]];
            [_arrayLock unlock];
        }
    } @catch (NSException *exception) {
    } @finally {
    }
    return allItems;
}

- (MBAPMDoctorEventModel *)getLatestEvent {
    [_arrayLock lock];
    NSInteger index = (_tail - 1 + self.capacity) % self.capacity;
    MBAPMDoctorEventModel *model = (MBAPMDoctorEventModel *)_array[index];
    [_arrayLock unlock];
    
    return model;
}

@end
