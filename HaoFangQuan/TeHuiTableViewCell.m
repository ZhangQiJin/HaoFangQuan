//
//  TeHuiTableViewCell.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "TeHuiTableViewCell.h"

@implementation TeHuiTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.liJiTuiJianButton.layer.cornerRadius = 5;
    self.liJiTuiJianButton.layer.masksToBounds = YES;
    self.liJiTuiJianButton.layer.borderWidth = 0.5;
    self.liJiTuiJianButton.layer.borderColor = [[UIColor redColor]CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
