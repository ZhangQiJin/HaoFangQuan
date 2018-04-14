//
//  WSmySettingViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSmySettingViewController : UIViewController

- (IBAction)turnBack:(id)sender;
- (IBAction)logOut:(id)sender;
- (IBAction)customerCall:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *memoryDisplayLabel;
- (IBAction)clearMemory:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *servicePhoneLaebl;

@end
