//
//  WSTeachGuideViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/7/8.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSTeachGuideViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *teachScrollView;
- (IBAction)jumpToRegistVC:(id)sender;
- (IBAction)jumpToLoginPage:(id)sender;

@end
