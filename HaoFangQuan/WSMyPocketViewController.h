//
//  WSMyPocketViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/4/27.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSMyPocketViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *laseEarnLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalEarnLabel;
@property (weak, nonatomic) IBOutlet UILabel *availbelMoneyLabel;
- (IBAction)jumpToTiXianPage:(id)sender;
- (IBAction)jumpToTiXianPassWord:(id)sender;
@end
