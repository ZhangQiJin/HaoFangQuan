//
//  WSTiXianMiMaViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/6.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSTiXianMiMaViewController : UIViewController

- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *inputBackView;
- (IBAction)tiJiaoMiMaAction:(id)sender;
@property(copy,nonatomic)NSString *tiXianMoney;
@property(copy,nonatomic)NSString *bankID;
@property (weak, nonatomic) IBOutlet UIView *alertBackView;
- (IBAction)jumpToTiXianJiLuPage:(id)sender;
- (IBAction)jumpToWoDeQianBao:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *failureView;
- (IBAction)findBackPassword:(id)sender;
- (IBAction)inputAgain:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *tiXianMoneyLabel;
@end
