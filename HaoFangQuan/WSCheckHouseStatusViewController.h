//
//  WSCheckHouseStatusViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSCheckHouseStatusViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *houseStatusTabelView;
- (IBAction)turnBack:(id)sender;
@end
