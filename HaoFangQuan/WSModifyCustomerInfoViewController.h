//
//  WSModifyCustomerInfoViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myCustomerModel.h"
@interface WSModifyCustomerInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femalButton;
- (IBAction)changeSex:(id)sender;
- (IBAction)turnBack:(id)sender;
@property(strong,nonatomic)myCustomerModel *passedModel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end
