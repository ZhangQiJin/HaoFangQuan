//
//  WSSelectHouseTypeViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/4/29.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chooseHouseModel.h"

@protocol SelectedDesireHouseDelegate <NSObject>
-(void) didSelectedDesierHouseModel :(chooseHouseModel*)currentModel;
@end
@interface WSSelectHouseTypeViewController : UIViewController

- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *houseTypeTableView;
@property (weak, nonatomic) IBOutlet UILabel *selectedCountLabel;
@property(weak,nonatomic)id<SelectedDesireHouseDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *areaIndexButton;
@property (weak, nonatomic) IBOutlet UIButton *houseTypeIndexButton;
- (IBAction)chooseArea:(id)sender;
- (IBAction)changeHouseType:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UIButton *houseTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *selectedButtonA;
@property (weak, nonatomic) IBOutlet UIButton *selectedButtonB;
@end
