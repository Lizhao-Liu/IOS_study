//
//  MBAPMDebugMonitorDefine.h
//  MBAPMDebug
//
//  Created by Lizhao on 2023/8/10.
//

#import <Foundation/Foundation.h>
@import MBDebug;
@import MBUIKit;

#define MBAPMDebugMonitorSwitch @"APMMonitorSwitch"
#define MBAPMDebugMonitorTitle @"APM"

#define kMBAPMDebugMonitorLogModelRedColor [UIColor redColor];

#define kMBAPMDebugMonitorLogModelOrangeColor [UIColor colorWithHexString:@"#fa8c16"];

#define kMBAPMDebugMonitorLogModelYellowColor [UIColor colorWithHexString:@"#DAA520"];

#define kMBAPMDebugMonitorLogModelGreenColor [UIColor colorWithHexString:@"#52c41a"];

#define kMBAPMDebugMonitorLogModelCyanColor [UIColor colorWithHexString:@"#008B8B"];

#define kMBAPMDebugMonitorLogModelBlueColor [UIColor colorWithHexString:@"#1890ff"];

#define kMBAPMDebugMonitorLogModelPurpleColor [UIColor colorWithHexString:@"#800080"];

#define kMBAPMDebugMonitorLogModelVioletColor [UIColor colorWithHexString:@"#9400D3"];


static MBDebugMonitorTagModel *kMBAPMDebugMonitorLogModelRedTag(void) {
    MBDebugMonitorTagModel *tagModel = [[MBDebugMonitorTagModel alloc] init];
    tagModel.textColor = kMBAPMDebugMonitorLogModelRedColor; //红色
    tagModel.borderColor = [UIColor colorWithHexString:@"#ffa39e"];
    tagModel.bgColor = [UIColor colorWithHexString:@"#fff1f0"];
    return tagModel;
}

static MBDebugMonitorTagModel *kMBAPMDebugMonitorLogModelOrangeTag(void) {
    MBDebugMonitorTagModel *tagModel = [[MBDebugMonitorTagModel alloc] init];
    tagModel.textColor = kMBAPMDebugMonitorLogModelOrangeColor; //橙色
    tagModel.borderColor = [UIColor colorWithHexString:@"#ffd591"];
    tagModel.bgColor = [UIColor colorWithHexString:@"#fff7e6"];
    return tagModel;
}

static MBDebugMonitorTagModel *kMBAPMDebugMonitorLogModelYellowTag(void) {
    MBDebugMonitorTagModel *tagModel = [[MBDebugMonitorTagModel alloc] init];
    tagModel.textColor = kMBAPMDebugMonitorLogModelYellowColor; //黄色
    tagModel.borderColor = [UIColor colorWithHexString:@"#FAFAD2"];
    tagModel.bgColor = [UIColor colorWithHexString:@"#FFF8DC"];
    return tagModel;
}

static MBDebugMonitorTagModel *kMBAPMDebugMonitorLogModelGreenTag(void) {
    MBDebugMonitorTagModel *tagModel = [[MBDebugMonitorTagModel alloc] init];
    tagModel.textColor = kMBAPMDebugMonitorLogModelGreenColor; //绿色
    tagModel.borderColor = [UIColor colorWithHexString:@"#b7eb8f"];
    tagModel.bgColor = [UIColor colorWithHexString:@"#f6ffed"];
    return tagModel;
}

static MBDebugMonitorTagModel *kMBAPMDebugMonitorLogModelCyanTag(void) {
    MBDebugMonitorTagModel *tagModel = [[MBDebugMonitorTagModel alloc] init];
    tagModel.textColor = kMBAPMDebugMonitorLogModelCyanColor;//青色
    tagModel.borderColor = [UIColor colorWithHexString:@"#00CED1"];
    tagModel.bgColor = [UIColor colorWithHexString:@"#E1FFFF"];
    return tagModel;
}

static MBDebugMonitorTagModel *kMBAPMDebugMonitorLogModelBlueTag(void) {
    MBDebugMonitorTagModel *tagModel = [[MBDebugMonitorTagModel alloc] init];
    tagModel.textColor = kMBAPMDebugMonitorLogModelBlueColor; //蓝色
    tagModel.borderColor = [UIColor colorWithHexString:@"#91d5ff"];
    tagModel.bgColor = [UIColor colorWithHexString:@"#e6f7ff"];
    return tagModel;
}

static MBDebugMonitorTagModel *kMBAPMDebugMonitorLogModelPurpleTag(void) {
    MBDebugMonitorTagModel *tagModel = [[MBDebugMonitorTagModel alloc] init];
    tagModel.textColor = kMBAPMDebugMonitorLogModelPurpleColor; //紫色
    tagModel.borderColor = [UIColor colorWithHexString:@"#EE82EE"];
    tagModel.bgColor = [UIColor colorWithHexString:@"#D8BFD8"];
    return tagModel;
}


static MBDebugMonitorTagModel *kMBAPMDebugMonitorLogModelVioletTag(void) {
    MBDebugMonitorTagModel *tagModel = [[MBDebugMonitorTagModel alloc] init];
    tagModel.textColor = kMBAPMDebugMonitorLogModelVioletColor;
    tagModel.borderColor = [UIColor colorWithHexString:@"#8A2BE2"];
    tagModel.bgColor = [UIColor colorWithHexString:@"#9370DB"];
    return tagModel;
}


