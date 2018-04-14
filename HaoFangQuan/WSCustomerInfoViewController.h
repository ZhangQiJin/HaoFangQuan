//
//  WSCustomerInfoViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myCustomerModel.h"
@interface WSCustomerInfoViewController : UIViewController

- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *purpersLabel;
@property (weak, nonatomic) IBOutlet UILabel *apartmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRangLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property(strong,nonatomic)myCustomerModel *passedModel;
- (IBAction)jumpToModifyCustomerInfoVC:(id)sender;
@end
