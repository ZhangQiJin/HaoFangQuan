//
//  WSUserRegistViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/22.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSUserRegistViewController : UIViewController

- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *configButtonBackView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *configCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *investTextField;
- (IBAction)changeTextFieldType:(id)sender;
- (IBAction)completeUserRegest:(id)sender;

@property(copy,nonatomic)NSString *pushIndex;
- (IBAction)addPhoneNumber:(id)sender;
- (IBAction)addConfigCode:(id)sender;
- (IBAction)setPassWord:(id)sender;
- (IBAction)doneRegest:(id)sender;
- (IBAction)dongAddRecomendPerson:(id)sender;
@end
