//
//  MBDebugMonitorCellViewModel.m
//  MBDebug
//
//  Created by Lizhao on 2023/8/2.
//

#import "MBDebugMonitorLogCellViewModel.h"
@import MBFoundation;

@implementation MBDebugMonitorTagModel


@end


@implementation MBDebugMonitorCellStyleModel


@end


@implementation MBDebugMonitorCellViewModel

- (MBDebugMontiorEventLocatorModel *)locatorModel {
    id<MBDebugMonitorLogCellObject> model = (id<MBDebugMonitorLogCellObject>)self.originalObject;
    if([model respondsToSelector:@selector(locatorModel)]){
        return  [((id<MBDebugMonitorLogCellObject>)self.originalObject) locatorModel];
    }
    return nil;
    
}

@end


@implementation MBDebugMonitorLogCellViewModel

+ (instancetype)cellModelWithObject:(id<MBDebugMonitorLogCellObject>)object {
    if(!object || ![object conformsToProtocol:@protocol(MBDebugMonitorLogCellObject)]){
        return nil;
    }
    MBDebugMonitorLogCellViewModel *model = [[MBDebugMonitorLogCellViewModel alloc] init];
    model.originalObject = object;
    model.isRead = NO;
    return model;
}

- (MBDebugMonitorTagModel *)tagModel {
    id<MBDebugMonitorLogCellObject> model = (id<MBDebugMonitorLogCellObject>)self.originalObject;
    if([model respondsToSelector:@selector(tagModel)]){
        return  [((id<MBDebugMonitorLogCellObject>)self.originalObject) tagModel];
    }
    return nil;
    
}


- (NSString *)detailStr {
    id<MBDebugMonitorLogCellObject> model = (id<MBDebugMonitorLogCellObject>)self.originalObject;
    if([model respondsToSelector:@selector(detail)]){
        return  [((id<MBDebugMonitorLogCellObject>)self.originalObject) detail];
    }
    return @"";
}

- (NSString *)timeStr {
    NSTimeInterval time = [((id<MBDebugMonitorLogCellObject>)self.originalObject) time];
    return [NSDateFormatter mb_stringWithDateWithDate:[NSDate dateWithTimeIntervalSince1970:time] format:@"yyyy-MM-dd HH:mm:ss"]; ;
}

- (NSString *)summaryStr {
    return [((id<MBDebugMonitorLogCellObject>)self.originalObject) summary];
}

- (NSArray<NSString *> *)attributes {
    id<MBDebugMonitorLogCellObject> model = (id<MBDebugMonitorLogCellObject>)self.originalObject;
    if([model respondsToSelector:@selector(attributes)]){
        NSArray *attributes = [((id<MBDebugMonitorLogCellObject>)self.originalObject) attributes];
        if(attributes && attributes.count > 0){
            return attributes;
        }
    }
    return nil;
}

- (MBDebugMonitorCellStyleModel *)styleModel {
    id<MBDebugMonitorLogCellObject> model = (id<MBDebugMonitorLogCellObject>)self.originalObject;
    if([model respondsToSelector:@selector(styleModel)]){
        return  [((id<MBDebugMonitorLogCellObject>)self.originalObject) styleModel];
    }
    return nil;
}


- (BOOL)isError {
    return [self.originalObject isErrorObject];
}

- (NSString *)sourceStr {
    id<MBDebugMonitorLogCellObject> model = (id<MBDebugMonitorLogCellObject>)self.originalObject;
    if([model respondsToSelector:@selector(source)]){
        return  [((id<MBDebugMonitorLogCellObject>)self.originalObject) source];
    }
    return @"";
}

@end
