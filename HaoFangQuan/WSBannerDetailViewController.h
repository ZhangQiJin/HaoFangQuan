//
//  WSBannerDetailViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/6/23.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSBannerDetailViewController : UIViewController
- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *houseImageScrollView;
@property (weak, nonatomic) IBOutlet UILabel *selectIndexLabel;
- (IBAction)checkHuXing:(id)sender;
- (IBAction)checkZhouBian:(id)sender;
- (IBAction)checkXiaoGuo:(id)sender;

@property(copy,nonatomic)NSString *passedName;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLabel;

//@property(strong,nonatomic)NSMutableArray *huXingTuArray;
//@property(strong,nonatomic)NSMutableArray *xiaoGuoTuArray;
@property(strong,nonatomic)NSArray *passedBannerArray;
@property (weak, nonatomic) IBOutlet UILabel *imageCountDisplayLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightSelctedIndexLabel;
@end
