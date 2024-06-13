//
//  HCBScanMaskView.h
//  NewDriver4iOS
//
//  Created by yangtianyin on 16/1/13.
//  Copyright © 2016年 苼茹夏花. All rights reserved.
//

#import <UIKit/UIKit.h>

#define pWith (self.frame.size.width - 100)
#define scanFrame(pWidth, pHeight) CGRectMake(50, (self.frame.size.height - pWidth) / 2 - 50, pWidth, pHeight)

#define scanLineBegin ((self.frame.size.height - pWith) / 2 - 50)
#define scanLineEnd ((self.frame.size.height - pWith) / 2 - 50 + self.frame.size.width - 100)

@interface HCBScanMaskView : UIView

@end
