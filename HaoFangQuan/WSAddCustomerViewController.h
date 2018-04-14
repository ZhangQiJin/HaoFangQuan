//
//  WSAddCustomerViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/6/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myCustomerModel.h"
@interface WSAddCustomerViewController : UIViewController

- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *purposeLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRangeLabel;
- (IBAction)finishAddCustomer:(id)sender;
- (IBAction)choosePurpose:(id)sender;
- (IBAction)chooseHouseType:(id)sender;
- (IBAction)choosePriceRange:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
- (IBAction)chooseHeadImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *chooseBackView;
- (IBAction)confirmCurrentChoose:(id)sender;
- (IBAction)cancelCurrentChoose:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *chooseTableView;
@property (weak, nonatomic) IBOutlet UIButton *purpuseChooseButton;
@property (weak, nonatomic) IBOutlet UIButton *apartmentChooseButton;
@property (weak, nonatomic) IBOutlet UIButton *priceRangeChooseButton;

@property(copy,nonatomic)NSString *showIndex;
@property(strong,nonatomic)myCustomerModel *passedModel;
@property (weak, nonatomic) IBOutlet UILabel *objectLabel;
@end
