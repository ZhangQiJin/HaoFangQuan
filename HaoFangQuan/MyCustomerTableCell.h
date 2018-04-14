//
//  MyCustomerTableCell.h
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCustomerTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *customerHeadImageView;

@property (weak, nonatomic) IBOutlet UIButton *liJiTuiJianButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *yiXiangFangWuLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRangeLabel;
@property (weak, nonatomic) IBOutlet UIButton *callCustomerButton;
@end
