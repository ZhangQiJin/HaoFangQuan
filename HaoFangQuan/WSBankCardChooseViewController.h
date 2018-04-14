//
//  WSBankCardChooseViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/6/10.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSBankCardChooseViewController : UIViewController

- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *cardTypeTableView;
@end
