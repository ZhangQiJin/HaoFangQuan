//
//  WSXianShiTeHuiViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSXianShiTeHuiViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *teHuiTableView;

@property (weak, nonatomic) IBOutlet UIButton *areaIndexButton;
@property (weak, nonatomic) IBOutlet UIButton *houseTypeIndexButton;
- (IBAction)chooseArea:(id)sender;
- (IBAction)changeHouseType:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UIButton *houseTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *selectedButtonA;
@property (weak, nonatomic) IBOutlet UIButton *selectedButtonB;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property(copy,nonatomic)NSString *passedCity;
@property (weak, nonatomic) IBOutlet UIScrollView *adScrollView;
@property (weak, nonatomic) IBOutlet UIButton *turnBackButton;

@property(copy,nonatomic)NSString *pushIndex;
- (IBAction)turnPushBack:(id)sender;
@end
