//
//  WSTianJianYinHangKaViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/4.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSTianJianYinHangKaViewController : UIViewController


- (IBAction)turnBack:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTF;
@property (weak, nonatomic) IBOutlet UILabel *bankCardDisplayLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *clearTextButton;
- (IBAction)submitAddedBankCard:(id)sender;
- (IBAction)clearTextContent:(id)sender;
- (IBAction)willAddCardNumber:(id)sender;
- (IBAction)didFinishAddCardInfo:(id)sender;
- (IBAction)didFinishAddPhoneNumber:(id)sender;
@end
