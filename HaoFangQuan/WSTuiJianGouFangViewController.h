//
//  WSTuiJianGouFangViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/4/29.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "chooseHouseModel.h"
@interface WSTuiJianGouFangViewController : UIViewController

- (IBAction)turnBack:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *nameTFCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneTFCancelButton;
- (IBAction)deleteTextFieldContent:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
- (IBAction)choosePhoneContact:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *selectedHouseTabelView;
- (IBAction)submitRecomend:(id)sender;
@property(strong,nonatomic)NSMutableArray *disPlayData;
//@property(strong,nonatomic)chooseHouseModel *passedModel;
@property(copy,nonatomic)NSString *passedName;
@property(copy,nonatomic)NSString *passedPhone;
@property (weak, nonatomic) IBOutlet UIButton *chooseContactButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)inPutFinished:(id)sender;
- (IBAction)willInPutPhone:(id)sender;
- (IBAction)completeInput:(id)sender;
@end
