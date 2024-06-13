//
//  MBThreadStackModel.m
//  MBAPMLib
//
//  Created by FDW on 2022/5/25.
//

#import "MBThreadStackModel.h"

@implementation MBThreadStackModel

- (NSString *)stackDescription {
    NSString *des;
    for (MBThreadStackPerModel *perModel in self.stackPerModelArray) {
        if (!des.length) {
            des = perModel.stack;
        } else {
            des = [NSString stringWithFormat:@"%@ \n %@\n", des, perModel.stack];
        }
    }
    return des;
}

- (NSMutableArray<MBThreadStackPerModel *> *)stackPerModelArray {
    if (!_stackPerModelArray) {
        _stackPerModelArray = @[].mutableCopy;
    }
    return _stackPerModelArray;
}
@end


@implementation MBThreadStackPerModel {
    NSArray *_addressArray;
}

- (uintptr_t )getCurAddress {
    uintptr_t cAddress = ((NSNumber *)self.addressArray[1]).longValue;
    return cAddress;
}
- (NSString *)getCurFname {
    NSString *cFname = self.addressArray.firstObject;
    return cFname;
}

- (long )getOffset {
   long offset = ((NSNumber *)self.addressArray.lastObject).longValue;
    return offset;
}

- (NSArray *)addressArray {
    if (!_addressArray) {
        _addressArray = [self.stack componentsSeparatedByString:@" "];
    }
    return _addressArray;
}
@end

