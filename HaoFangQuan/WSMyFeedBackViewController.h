//
//  WSMyFeedBackViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/6/17.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSMyFeedBackViewController : UIViewController
- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@end
