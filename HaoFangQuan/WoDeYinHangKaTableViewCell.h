//
//  WoDeYinHangKaTableViewCell.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/4.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WoDeYinHangKaTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property(assign,nonatomic)NSUInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTailNumLabel;
@end
