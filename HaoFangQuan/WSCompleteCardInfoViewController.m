//
//  WSCompleteCardInfoViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/6.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSCompleteCardInfoViewController.h"

@interface WSCompleteCardInfoViewController ()<UITextFieldDelegate>

@end

@implementation WSCompleteCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *selectedCard = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedBack"];
    if (selectedCard.length>0) {
        self.bankCardDisplayLabel.text = selectedCard;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.clearTextButton.hidden = NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length >0 ) {
        self.nextStepButton.enabled = YES;
        self.nextStepButton.backgroundColor = [UIColor orangeColor];
    }
}
- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clearTextContent:(id)sender {
    self.phoneTF.text = @"";
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
