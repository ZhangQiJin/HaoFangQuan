//
//  Header.h
//
//
//  Created by 高山 on 14-10-25.
//  Copyright (c) 2014年 高山. All rights reserved.
//

#ifndef _____Header_h
#define _____Header_h


//******屏幕高度
#define LCDH [[UIScreen mainScreen]bounds].size.height
//******屏幕宽度
#define LCDW [[UIScreen mainScreen]bounds].size.width
//******本地读取图片
#define  App_ContentFile(aFileName,aFileType) [[NSBundle mainBundle]pathForResource:aFileName ofType:aFileType]
//判断设备是否是iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
/**
 *1用户注册：
 接口说明：参数，json字符串:{"userName":"张三","phoneNum":"18912345678","password":"e10adc3949ba59abbe56e057f20f883e","invitePhoneNum":"18988888888","verifyCode":"123456"}
 接口返回：ret为0时成功，其它：为100时参数无效，101手机号已存在。102验证码不存在或已过期(1小时有效期，下同)'
*/
#define userRegest @"http://120.25.153.217/index.php/Api/Reg/index"

/**
 *2获取验证码：
 接口说明：参数，json字符串：{"phoneNum":"18912345678"}
 */
#define ReceiveConfigMessage @"http://120.25.153.217/index.php/Api/Reg/getcode"

/**
 *3用户登录：
 接口说明：参数，json字符串：{"phoneNum":"18912345678"}
 */
#define userLogin @"http://120.25.153.217/index.php/Api/Reg/login"

/**
 *4找回密码：
 接口说明：参数{"phoneNum":"18912345678","password":"e10adc3949ba59abbe56e057f20f883e","verifyCode":"123456"}
 */
#define findBackPassWord @"http://120.25.153.217/index.php/Api/Reg/forgetpass"

/**
 *5省份城市列表数据
 接口说明：无参数。返回省份province.name和其下属city名称
 */
#define receiveAllCityData @"http://120.25.153.217/index.php/Api/Normal/allcity"

/**
 *6房源类型接口
 接口说明：无参数。返回房源类型数据。
 */
#define houseTypeChoose @"http://120.25.153.217/index.php/Api/Normal/room"

/**
 *7首页接口
 接口说明：参数tokenId,返回房源数据及img banner图片。
 */
#define loadFirstPageData @"http://120.25.153.217/index.php/Api/Index/index"

/**
 *7好房源列表页接口
 接口说明：参数{"filterArea":"兰州","filterType":"别墅","pageNum":"0","pageSize":"20"}
 */
#define loadHaoFangQuanHouseData @"http://120.25.153.217/index.php/Api/House/index"

/**
 *8特惠页接口：
 接口说明：参数{"tokenId":"xxxxxxx","filterArea":"兰州","filterType":"别墅","pageNum":"0","pageSize":"20"}。
 */
#define loadSecondPageData @"http://120.25.153.217/index.php/Api/House/houselist"

/**
 *9用户钱包接口：
 接口说明：传入token
 */
#define userWallet @"http://120.25.153.217/index.php/Api/User/wallet"

/**
 *10：用户中心我的页面接口
 接口说明：传入token
 */
#define receiveUserInfo @"http://120.25.153.217/index.php/Api/User/index"

/**
 *11：用户修改手机号码：
 接口说明：参数tokenId，phoneNum，newPhoneNum
 */
#define changePhoneNumber @"http://120.25.153.217/index.php/Api/User/updatephone"

/**  http://115.28.46.58:8888/index.php/Api/Normal/logs ceshi
 *12：用户修改密码：
 接口说明：参数tokenId，password，newPassword
 */
#define changeLoginPassWord @"http://120.25.153.217/index.php/Api/User/updatepassword"

/**
 *13：用户消息列表：
 接口说明：参数tokenId，pageNum":"2", "pageSize"
 */
#define myMessage @"http://120.25.153.217/index.php/Api/User/message"

/**
 *14：用户删除消息：
 接口说明：参数tokenId，删除的消息.id
 */
#define delMyMessage @"http://120.25.153.217/index.php/Api/User/delmessage"

/**
 *15：用户团队：
 接口说明：参数tokenId
 */
#define myTeam @"http://120.25.153.217/index.php/Api/User/team"

/**
 *16：用户提交收藏房源：(pending)
 接口说明：传入token，房源id
 */
#define didCollectHouse @"http://120.25.153.217/index.php/Api/User/docollect"

/**
 *17：用户收藏房源列表：
 接口说明：传入token
 */
#define allCollect @"http://120.25.153.217/index.php/Api/User/collect"

/**
 *18：用户客户列表：
 接口说明：传入token，{"tokenId":"83335398057b0947d0dc16d3cdf61131","pageNum":"0","pageSize":"5"}
 */
#define myCustomers @"http://120.25.153.217/index.php/Api/User/customer"

/**
 *19：删除我的客户接口：
 接口说明：传入token，传入客户id值。
 */
#define delCustomers @"http://120.25.153.217/index.php/Api/User/delcustomer"

/**
 *20：添加客户接口：
 接口说明：post客户json数据：{"tokenId":"1db52007515dfce48024806728eab6a5","name": "张国家","phoneNum": "13366665555","purpose": "老人住房","apartment":"两室一厅","priceRange": "20-30万"}及头像文件file。
 */
#define addCustomers @"http://120.25.153.217/index.php/Api/User/addcustomer"

/**
 *21：提交推荐房源接口：(pending)
 接口说明：post客户json数据：{"tokenId":"1db52007515dfce48024806728eab6a5","id":"11","houseId":"1"}。
 */
#define submitRecomHouse @"http://120.25.153.217/index.php/Api/User/recomhouse"

/**
 *22：新增推荐房源接口（向已经存在的客户添加新的推荐房源）(废)
 接口说明：post客户json数据：{"tokenId":"1db52007515dfce48024806728eab6a5","id":"11","houseId":"1"}
 */
#define addSubmitRecomHouse @"http://120.25.153.217/index.php/Api/User/addrecomhouse"

/**
 *23：取消推荐房源接口：(待后台确认)
 接口说明：post客户json数据：{"tokenId":"1db52007515dfce48024806728eab6a5","id":"11","houseId":"1"}。
 */
#define delRecomHouse @"http://120.25.153.217/index.php/Api/User/delrecomhouse"

/**
 *24：用户反馈问题：
 接口说明：post接口json数据：{"tokenId":"1db52007515dfce48024806728eab6a5","content":"关于界面,能不能可以变换主题"}。
 */
#define didMyFeedBack @"http://120.25.153.217/index.php/Api/User/dofeedback"

/**
 *25：用户反馈问题列表：
 接口说明：post接口json数据：{"tokenId":"1db52007515dfce48024806728eab6a5"}。
 */
#define FeedBackList @"http://120.25.153.217/index.php/Api/User/feedback"

/**
 *26：修改个人地区：(pending)
 接口说明：post接口json数据：{"tokenId":"1db52007515dfce48024806728eab6a5","proviece":"甘肃","city":"兰州"}。
 */
#define changeMyArea @"http://120.25.153.217/index.php/Api/User/setcity"

/**
 *27：修改我的姓名接口：
 接口说明：post接口json数据：'{"tokenId":"1db52007515dfce48024806728eab6a5","userName":"张三"}。
 */
#define changeMyName @"http://120.25.153.217/index.php/Api/User/updatename"

/**
 *28：修改用户头像：(pending)
 接口说明：post接口json数据：'{"tokenId":"1db52007515dfce48024806728eab6a5"}'及文件$_FILE
 */
#define changeMyHeadImage @"http://120.25.153.217/index.php/Api/User/updateface"

/**
 *29：提现密码设置
 接口说明：post接口json数据：{"tokenId":"1db52007515dfce48024806728eab6a5","pinPassword":"e10adc3949ba59abbe56e057f20f883e"} 。
 */
#define setTiXianPassword @"http://120.25.153.217/index.php/Api/User/setmoneypass"

/**
 *30：提现密码校验接口(pending)
 接口说明：post接口json数据：{"tokenId":"1db52007515dfce48024806728eab6a5","pinPassword":"e10adc3949ba59abbe56e057f20f883e"}
 */
#define verifyTiXianPassword @"http://120.25.153.217/index.php/Api/User/checkmoneypass"

/**
 *31：用户提现记录接口
 接口说明：post接口json数据{"tokenId":"1db52007515dfce48024806728eab6a5","pageNum":"0","pageSize":"5"}'
 */
#define userTiXianRecord @"http://120.25.153.217/index.php/Api/User/withdrawals"

/**
 *32：客户购房状态列表接口(pending)
 接口说明：post接口json数据：{"tokenId":"1db52007515dfce48024806728eab6a5","id":"6"}
 */
#define customerStatus @"http://120.25.153.217/index.php/Api/User/customerstatus"

/**
 *33：好房圈资迅列表页接口
 接口说明：参数{"pageNum":"0","pageSize":"2"}
 */
#define haoFangQuanNews @"http://120.25.153.217/index.php/Api/News/index"

/**
 *34：关于好房圈接口
 接口说明：参数无,如走html实现，请从web页面底部取得关于我们的链接
 */
#define aboutHaoFangQuan @"http://120.25.153.217/index.php/Api/Page/about"

/**
 *35：钱包可提现余额、本次最多转出金额接口
 接口说明：post接口json数据{"tokenId":"1db52007515dfce48024806728eab6a5"}'
 */
#define walletAvalibleMoney @"http://120.25.153.217/index.php/Api/User/maxwithdrawals"

/**
 *36：添加单条银行卡信息接口(pending)
 接口说明：post接口json数据{"tokenId":"1db52007515dfce48024806728eab6a5","owner":"唐国强","cardNum":"62230568984578512","bankId":"2","phoneNum":"18953230995","verifyCode":"9132"}'（有bankId可以不要bank吧？） 
 */
#define addNewBankCard @"http://120.25.153.217/index.php/Api/User/addcard"

/**
 *37：我的银行卡列表接口
 接口说明：post接口json数据{"tokenId":"1db52007515dfce48024806728eab6a5","pageNum":"0","pageSize":"4"}'
 */
#define allMyCard @"http://120.25.153.217/index.php/Api/User/mycard"

/**
 *38：客户购房状态列表接口
 接口说明：post接口json数据：{"tokenId":"1db52007515dfce48024806728eab6a5","id":"6"}
 */
#define customerStateDetail @"http://120.25.153.217/index.php/Api/User/customerstatus"

/**
 *39：生成我的分享邀请码
 接口说明：post接口json数据{"tokenId":"1db52007515dfce48024806728eab6a5","signup":"0"}'
 */
#define receiveInvestCode @"http://120.25.153.217/index.php/Api/User/invitecode"

/**
 *40：我的金豆列表接口
 接口说明：post接口json数据 {"tokenId":"24fdf1ae4be3a2ffddf8adfe54a0c76d",“pageNum":"0","pageSize":"20"}
 */
#define allMyGoldList @"http://120.25.153.217/index.php/Api/User/goldlist"

/**
 *41：领取金豆接口
 接口说明：post接口json数据 {"tokenId":"24fdf1ae4be3a2ffddf8adfe54a0c76d",“exchangeGold":"100"}
 */
#define getMyGoldBean @"http://120.25.153.217/index.php/Api/User/getgold"

/**
 *42：好房源详情页接口
 接口说明：参数：{"id":"3","tokenId":"1db52007515dfce48024806728eab6a5"} */
#define houseDetail @"http://120.25.153.217/index.php/Api/House/show"

/**
 *43：房源按关键词搜索接口
 接口说明：参数{"tokenId":"1db52007515dfce48024806728eab6a5","search":"七里河","type":"0","pageNum":"0","pageSize":"5"} 
 */
#define houseSearch @"http://120.25.153.217/index.php/Api/House/search"

/**
 *43：获取房源类型
 接口说明：参数{"tokenId":"1db52007515dfce48024806728eab6a5","search":"七里河","type":"0","pageNum":"0","pageSize":"5"}
 */
#define houseSearch @"http://120.25.153.217/index.php/Api/House/search"

/**
 *44：用户钱包明细接口
 接口说明：post接口json数据 {"tokenId":"24fdf1ae4be3a2ffddf8adfe54a0c76d",”type”:”0”,“pageNum":"0","pageSize":"20"}type参数值：0,赚佣金，1分享返现，2注册送积分，3佣金提现，传空为所有数据
 */
#define GetWalletDetail @"http://120.25.153.217/index.php/Api/User/moneylist"
/**
 *45：校验提现密码
 接口说明：post接口json数据：{"tokenId":"1db52007515dfce48024806728eab6a5","pinPassword":"e10adc3949ba59abbe56e057f20f883e"}
 */
#define verifyTiXianMiMa @"http://120.25.153.217/index.php/Api/User/checkmoneypass"
/**
 *45：用户执行提现操作接口
 接口说明：post接口json数据{"tokenId":"1db52007515dfce48024806728eab6a5","money":"250","id":"12"}'
 */
#define startTiXian @"http://120.25.153.217/index.php/Api/User/dowithdrawals"
/**
 *46：当前团队成员的客户列表
 */
#define teamCustomerList @"http://120.25.153.217/index.php/Api/User/teamCustomer"
/**
 *47：当前团队成员的客户购房状态
 */
#define teamCustomerBuyState @"http://120.25.153.217/index.php/Api/User/teamCustomerStatus"
#endif
