//
//  tiXianRecordModel.m
//  HaoFangQuan
//
//  Created by Muse on 15/6/10.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "tiXianRecordModel.h"

@implementation tiXianRecordModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.detailRecordsArray = [NSMutableArray array];
    }
    return self;
}
@end
