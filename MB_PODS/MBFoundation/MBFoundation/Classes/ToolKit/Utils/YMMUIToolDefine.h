//
//  YMMUIToolDefine.h
//  MBFoundation
//
//  Created by William Chang on 2021/8/23.
//

//#import "MBFoundation-Swift.h"
#ifndef YMMUIToolDefine_h
#define YMMUIToolDefine_h

#ifndef YMMDIMESCALE
#define YMMDIMESCALE(val)   ([MBUITool scale:val])
#endif
#ifndef YMMDIMESCALEW
#define YMMDIMESCALEW(val)  ([MBUITool scaleW:val])
#endif
#ifndef YMMDIMESCALEH
#define YMMDIMESCALEH(val)  ([MBUITool scaleH:val])
#endif
#ifndef kCompany_IS_YMM
#define kCompany_IS_YMM [MBAppUtil appComanyIsYMM]
#endif
#ifndef kCargoQuoteTimeCountDown
#define kCargoQuoteTimeCountDown @"kCargoQuoteTimeCountDown"
#endif

#endif /* YMMUIToolDefine_h */
