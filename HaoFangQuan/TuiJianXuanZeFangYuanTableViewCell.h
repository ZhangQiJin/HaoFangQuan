//
//  TuiJianXuanZeFangYuanTableViewCell.h
//  HaoFangQuan
//
//  Created by Muse on 15/4/29.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuiJianXuanZeFangYuanTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tuiJianHouseImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property(assign,nonatomic)NSUInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end
