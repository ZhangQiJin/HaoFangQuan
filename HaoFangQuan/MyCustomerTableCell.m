//
//  MyCustomerTableCell.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "MyCustomerTableCell.h"

@implementation MyCustomerTableCell

- (void)awakeFromNib {
    // Initialization code
    self.liJiTuiJianButton.layer.cornerRadius = 10;
    self.liJiTuiJianButton.layer.masksToBounds = YES;
    self.liJiTuiJianButton.layer.borderWidth = 0.5;
    self.liJiTuiJianButton.layer.borderColor = [[UIColor colorWithRed:246.0/255 green:73.0/255 blue:118.0/255 alpha:1.0]CGColor];
    self.customerHeadImageView.layer.cornerRadius = 30.0;
    self.customerHeadImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
