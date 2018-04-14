//
//  WSWalletDetailViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/6/11.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSWalletDetailViewController : UIViewController
- (IBAction)turnBack:(id)sender;

- (IBAction)changeType:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *walletDetailTableView;
@property (weak, nonatomic) IBOutlet UIButton *chooseStateIndexButton;
@property (weak, nonatomic) IBOutlet UIView *selceteBackView;
@end
