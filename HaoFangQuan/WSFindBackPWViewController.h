//
//  WSFindBackPWViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/22.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSFindBackPWViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *configButtonBackView;
- (IBAction)turnBack:(id)sender;
- (IBAction)changeTextFieldType:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *changedTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *configCodeTextField;
- (IBAction)completeFindBackPassWord:(id)sender;
- (IBAction)startInPutConfigCode:(id)sender;
- (IBAction)startInPutNewPw:(id)sender;
- (IBAction)completeInput:(id)sender;
@end
