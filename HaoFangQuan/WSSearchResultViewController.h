//
//  WSSearchResultViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/6/9.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSSearchResultViewController : UIViewController

- (IBAction)turnBack:(id)sender;
@property(copy,nonatomic)NSString *search;
@property(copy,nonatomic)NSString *type;

@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;
@property (weak, nonatomic) IBOutlet UIView *noResultView;
@end
