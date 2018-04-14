//
//  WSMySharingViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/6/16.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSMySharingViewController : UIViewController
- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sharingCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *receiveShareButton;
- (IBAction)sharingAction:(id)sender;


@end
