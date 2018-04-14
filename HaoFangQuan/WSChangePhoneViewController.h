//
//  WSChangePhoneViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WSChangePhoneDelegate <NSObject>
-(void)changePhoneViewControllerFinishEditWithChangedPhone :(NSString*)string;
@end
@interface WSChangePhoneViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)clearPhoneTF:(id)sender;
- (IBAction)finishChangePhoneNum:(id)sender;
- (IBAction)turnBack:(id)sender;

@property(weak,nonatomic)id<WSChangePhoneDelegate>delegate;
@property(copy,nonatomic)NSString *passedPhone;
@property (weak, nonatomic) IBOutlet UILabel *orginPhoneLabel;
@end
