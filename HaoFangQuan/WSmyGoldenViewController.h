//
//  WSmyGoldenViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSmyGoldenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *goldenTableView;
- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *totalGoldBeanLabel;
@property (weak, nonatomic) IBOutlet UILabel *sucessRecomendLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalRecomendLabel;
- (IBAction)receiveGoldBean:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *viewCoverButton;
- (IBAction)hideCoverViewButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *goldTiQuBackView;
@property (weak, nonatomic) IBOutlet UILabel *avalbelGoldLabel;
@property (weak, nonatomic) IBOutlet UITextField *tiQuGoldCountTextField;
- (IBAction)cancelTiQuGold:(id)sender;

- (IBAction)confirmTiQu:(id)sender;
@end
