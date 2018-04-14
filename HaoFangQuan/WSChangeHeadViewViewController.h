//
//  WSChangeHeadViewViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSChangeHeadViewViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *bigHeadImageView;
- (IBAction)turnBack:(id)sender;
- (IBAction)chooseImageFromAlbum:(id)sender;
- (IBAction)takePhoto:(id)sender;
@end
