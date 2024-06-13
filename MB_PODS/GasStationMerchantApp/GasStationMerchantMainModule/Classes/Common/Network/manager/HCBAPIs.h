//
//  HCBAPIs.h
//  GasStationBiz
//
//  Created by ty on 2017/9/26.
//  Copyright © 2017年 56qq. All rights reserved.
//

#ifndef HCBAPIs_h
#define HCBAPIs_h



#pragma mark ========== sso ==========
#define ssohost_dev @"https://sso.dev-ag.56qq.com"
#define ssohost_qa  @"https://sso.qa-sh.56qq.com"
#define ssohost_pro @"https://sso.56qq.cn"

#define req_login_accountandpwd @"/common/login.do" //帐号号密码登录
#define req_login_accountandcode @"/common/app/mobile/login-by-code.do" //验证码登录
#define req_loginout @"/common/auth/logout.do"//登出

#pragma mark ========== jyz ==========
#define gashost_qa  @"https://jyz.qa-sh.56qq.com" //qa环境
#define gashost_dev @"https://jyz.dev-ag.56qq.com"
#define gashost_pro @"https://jyz.56qq.com"

#define req_login_verifycode @"/mobile/sms/send-verify-code"//@"/mobile/verify4code/get.do"
#define req_posuser_userinfo @"/mobile/pos/user/info"//登录用户信息查询
#define req_gasstation_verifycode @"/mobile/pos/user/sendVerifyCode" //获取更换手机号验证码
#define req_gasstation_modifymobile @"/mobile/pos/user/modifyMobile" //更换绑定的手机号
#define req_gasstation_orderdetail @"/mobile/pos/order/detail"//订单详情

#pragma mark ============= Enterprise ============
#define enterprisehost_dev @"https://gs-enterprise.dev-ag.56qq.com"
#define enterprisehost_qa  @"https://gs-enterprise.qa-sh.56qq.com"
#define enterprisehost_pro @"https://gs-enterprise.56qq.com"

#pragma mark ========== finance ==========
#define finance_qa  @"https://gs-finance.qa-sh.56qq.com" //qa环境
#define finance_dev @"https://gs-finance.dev-ag.56qq.com"
#define finance_pro @"https://gs-finance.56qq.com"

#pragma mark ========== MERCHANT ==========
#define MERCHANT_qa  @"https://gs-merchant.qa-sh.56qq.com"
#define MERCHANT_dev @"https://gs-merchant.qa-sh.56qq.com"
#define MERCHANT_pro @"https://gs-merchant.56qq.com"

#pragma mark ========== 网关地址 ==========
#define mmobile_Dev @"https://gs-mmobile.dev-ag.56qq.com"
#define mmobile_QA @"https://gs-mmobile.qa-sh.56qq.com"
#define mmobile_Pro @"https://gs-mmobile.56qq.com"

#define req_wallet_token @"/mobile/cashback/walletToken"


///common/app/mobile/login-by-code.do


#endif /* HCBAPIs_h */
