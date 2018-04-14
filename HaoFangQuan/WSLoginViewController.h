//
//  WSLoginViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/21.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSLoginViewController : UIViewController

- (IBAction)turnBack:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *loginPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordTextField;
- (IBAction)loginAction:(id)sender;

@property(copy,nonatomic)NSString *pushIndex;
- (IBAction)willInPutPassword:(id)sender;
- (IBAction)resignInput:(id)sender;
@end
