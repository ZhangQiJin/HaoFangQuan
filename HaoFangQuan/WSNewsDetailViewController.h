//
//  WSNewsDetailViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSNewsDetailViewController : UIViewController

- (IBAction)turnBack:(id)sender;
@property(copy,nonatomic)NSString *passedDetailURL;
@property (weak, nonatomic) IBOutlet UILabel *subJectLabel;
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
@property(copy,nonatomic)NSString *passedTitle;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
- (IBAction)delOrAddCollection:(id)sender;
@end
