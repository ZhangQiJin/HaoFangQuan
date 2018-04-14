//
//  WSChangeNameViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WSChangeNameDelegate <NSObject>
-(void)changeNameViewControllerFinishEditWithChangedName :(NSString*)string;
@end
@interface WSChangeNameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property(weak,nonatomic)id<WSChangeNameDelegate>delegate;
- (IBAction)finishChangeName:(id)sender;
- (IBAction)clearNameTF:(id)sender;
- (IBAction)turnBack:(id)sender;
@property(copy,nonatomic)NSString *passedName;
@property (weak, nonatomic) IBOutlet UILabel *orginNameLabel;
@end
