//
//  HCBCodeScanerMaskView.h
//  NewDriver4iOS
//
//  Created by yangtianyin on 16/1/13.
//  Copyright © 2016年 苼茹夏花. All rights reserved.
//

#import <UIKit/UIKit.h>

#define pWith (self.bounds.size.width - 100)
#define scanFrame(w, h) CGRectMake((self.bounds.size.width - w) / 2, (self.bounds.size.height - h) / 2, w, h)
#define scanLineBegin CGRectGetMinY(scanFrame(pWith, pWith))
#define scanLineEnd CGRectGetMaxY(scanFrame(pWith, pWith))

@interface HCBCodeScanerMaskView : UIView

@end
