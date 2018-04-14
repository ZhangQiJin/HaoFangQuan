//
//  WSmyCustomerViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSmyCustomerViewController : UIViewController

- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myCustomerTabelView;
@property (weak, nonatomic) IBOutlet UIView *noResultView;
@end
