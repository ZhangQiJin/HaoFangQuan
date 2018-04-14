//
//  WSFirstPageViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/4/27.
//  Copyright (c) 2015年 Muse. All rights reserved.


#import <UIKit/UIKit.h>

@interface WSFirstPageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *functionPadView;
@property (weak, nonatomic) IBOutlet UIImageView *areaSelectIndexImageView;
- (IBAction)chooseArea:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *currentCityNameLabel;


@property (weak, nonatomic) IBOutlet UIButton *youJiangYaoYueButton;

@property (weak, nonatomic) IBOutlet UIScrollView *adScrollView;
- (IBAction)jumpToYouJiangYaoYue:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *noDataDisplayView;
- (IBAction)jumpToZhuanYongJin:(id)sender;
@end
