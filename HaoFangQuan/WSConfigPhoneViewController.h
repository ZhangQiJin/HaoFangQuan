//
//  WSConfigPhoneViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/4.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSConfigPhoneViewController : UIViewController


- (IBAction)canNotReceiveCode:(id)sender;
- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *subJectLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

@property(copy,nonatomic)NSString *subJectWords;
@property(copy,nonatomic)NSString *alertWords;
- (IBAction)hideAlertView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *tiShiView;
@end
