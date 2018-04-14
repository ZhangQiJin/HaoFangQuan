//
//  WSAboutViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/4/27.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSAboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImagView;
- (IBAction)shareToFriends:(id)sender;
- (IBAction)jumpUserInfoOrLoginVC:(id)sender;
@end
