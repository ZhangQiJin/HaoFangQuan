//
//  haoFangQuanNewsModel.h
//  HaoFangQuan
//
//  Created by Muse on 15/6/9.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface haoFangQuanNewsModel : NSObject
@property(copy,nonatomic)NSString *newsID;
@property(copy,nonatomic)NSString *imgUrl;
@property(copy,nonatomic)NSString *title;
@property(copy,nonatomic)NSString *content;
@property(copy,nonatomic)NSString *time;
@property(copy,nonatomic)NSString *detailUrl;
@end
