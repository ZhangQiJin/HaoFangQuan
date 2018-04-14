//
//  WSHouseDetailViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/6/9.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "houseSourceModel.h"
@interface WSHouseDetailViewController : UIViewController
- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *houseImageScrollView;
- (IBAction)xiangQingCallAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *liJiTuiJianButton;
- (IBAction)liJiTuiJianAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *referanceView;

@property(copy,nonatomic)NSString *houseID;
@property(copy,nonatomic)NSString *houseName;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *openTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *yiChengJiaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *yiTuiJianLabel;
@property (weak, nonatomic) IBOutlet UILabel *yiYuYueLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneLabel;
@property (weak, nonatomic) IBOutlet MKMapView *detailMapView;
- (IBAction)UMSharing:(id)sender;

@property(copy,nonatomic)NSString *passedHouseType;
@property (weak, nonatomic) IBOutlet UILabel *huoDongShiJianlabel;
@property (weak, nonatomic) IBOutlet UILabel *shengYuTianShuLabel;
@property (weak, nonatomic) IBOutlet UIImageView *huiIconImageView;

@property(strong,nonatomic)houseSourceModel *passedHouseModel;
@end
