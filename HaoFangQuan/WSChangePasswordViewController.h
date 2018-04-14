//
//  WSChangePasswordViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSChangePasswordViewController : UIViewController

- (IBAction)turnBakc:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *originTextField;
@property (weak, nonatomic) IBOutlet UITextField *changeTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *changedClearButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmClearButton;
@property (weak, nonatomic) IBOutlet UIButton *swapeButton;
- (IBAction)submitChangedPassword:(id)sender;
- (IBAction)swapeTextFieldDisplay:(id)sender;
- (IBAction)clearChangedTextField:(id)sender;
- (IBAction)clearConfrimTextField:(id)sender;
@end
