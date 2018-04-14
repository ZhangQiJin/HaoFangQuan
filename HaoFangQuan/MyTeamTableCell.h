//
//  MyTeamTableCell.h
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTeamTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *teamerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@end
