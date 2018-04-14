//
//  WSCustomerListViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/9/23.
//  Copyright © 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSCustomerListViewController : UIViewController
- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *customerListTableView;
@property(copy,nonatomic)NSString *pasedTeamID;
@property (weak, nonatomic) IBOutlet UIView *noResultView;
@end
