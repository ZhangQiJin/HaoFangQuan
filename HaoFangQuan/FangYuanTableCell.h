//
//  FangYuanTableCell.h
//  HaoFangQuan
//
//  Created by Muse on 15/4/27.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FangYuanTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *houseImageView;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *housePromoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *recomendButton;
@end
