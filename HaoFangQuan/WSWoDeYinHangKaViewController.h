//
//  WSWoDeYinHangKaViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/4.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WoDeYinHangKaChooseDelegate <NSObject>
-(void)woDeYinHangKaDidChooseCardWithName :(NSString*)cardName image:(UIImage*)cardImage andWeiHao :(NSString*)weiHao andBankID :(NSString*)bankID andCardID :(NSString*)cardID;
@end

@interface WSWoDeYinHangKaViewController : UIViewController
- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *cardTableView;
@property(weak,nonatomic)id<WoDeYinHangKaChooseDelegate>delegate;
- (IBAction)jumpToAddCardPage:(id)sender;
@end
