//
//  WSNewestHouseViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/27.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSNewestHouseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *areaIndexButton;
@property (weak, nonatomic) IBOutlet UIButton *houseTypeIndexButton;
- (IBAction)chooseArea:(id)sender;
- (IBAction)changeHouseType:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UIButton *houseTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *selectedButtonA;
@property (weak, nonatomic) IBOutlet UIButton *selectedButtonB;

@property(copy,nonatomic)NSString *title;

- (IBAction)turnBack:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *newestHouseTabelView;
@end
