//
//  FangYuanTableCell.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/27.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "FangYuanTableCell.h"

@implementation FangYuanTableCell

- (void)awakeFromNib {
    // Initialization code
    self.recomendButton.layer.cornerRadius = 5;
    self.recomendButton.layer.masksToBounds = YES;
    self.recomendButton.layer.borderWidth = 0.5;
    self.recomendButton.layer.borderColor = [[UIColor redColor]CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
