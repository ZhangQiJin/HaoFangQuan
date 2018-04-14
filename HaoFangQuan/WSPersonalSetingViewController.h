//
//  WSPersonalSetingViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSPersonalSetingViewController : UIViewController

- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *samllHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
- (IBAction)chooseArea:(id)sender;
@property(copy,nonatomic)NSString *passedName;
@property(copy,nonatomic)NSString *passedPhone;
@property(copy,nonatomic)NSString *passedArea;

@end
