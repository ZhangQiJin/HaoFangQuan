//
//  WSCheckStatusDetailViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSCheckStatusDetailViewController : UIViewController
- (IBAction)turnBack:(id)sender;
@property(copy,nonatomic)NSString *passedID;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *purpersLabel;
@property (weak, nonatomic) IBOutlet UILabel *apartmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRangeLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *stateButtons;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *stateTimeLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *statusTextLabels;
@property(copy,nonatomic)NSString *pushIndex;
@end
