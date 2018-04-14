//
//  WSSearchViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/4.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSSearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *searchHistoryTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
- (IBAction)cancelSearch:(id)sender;
- (IBAction)deleteSearchHistory:(id)sender;
- (IBAction)startSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *houseTypeBackView;
@property (weak, nonatomic) IBOutlet UIButton *chooseStateIndexButton;

- (IBAction)chooseHouseType:(id)sender;

- (IBAction)selectdCurrentType:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *currentTypeLabel;

- (IBAction)finishInput:(id)sender;
@end
