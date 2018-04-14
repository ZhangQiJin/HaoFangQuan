//
//  WSConfirmSettingTiXianMiMaViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/6/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSConfirmSettingTiXianMiMaViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *inputBackView;
- (IBAction)turnBack:(id)sender;
@property(copy,nonatomic)NSString *passedPassword;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitSetting:(id)sender;
@end
