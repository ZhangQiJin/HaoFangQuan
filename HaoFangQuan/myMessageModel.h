//
//  myMessageModel.h
//  HaoFangQuan
//
//  Created by Muse on 15/6/4.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myMessageModel : NSObject
@property(copy,nonatomic)NSString *ID;
@property(copy,nonatomic)NSString *author;
@property(copy,nonatomic)NSString *time;
@property(copy,nonatomic)NSString *content;
@property(copy,nonatomic)NSString *isViewed;
@end
