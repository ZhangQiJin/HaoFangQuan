//
//  WSmyCollectionViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSmyCollectionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *myCollectionTableView;
- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *collectionCountLabel;
@property (weak, nonatomic) IBOutlet UIView *noCollView;
@end
