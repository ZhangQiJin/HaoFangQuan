//
//  WSCompleteCardInfoViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/6.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSCompleteCardInfoViewController : UIViewController

- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *clearTextButton;
- (IBAction)clearTextContent:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UILabel *bankCardDisplayLabel;
@end
