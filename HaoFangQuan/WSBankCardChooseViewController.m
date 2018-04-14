//
//  WSBankCardChooseViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/6/10.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSBankCardChooseViewController.h"

@interface WSBankCardChooseViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSArray *bankNameArray;
@end

@implementation WSBankCardChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.bankNameArray = @[@"中国工商银行",@"中国建设银行",@"招商银行",@"交通银行",@"中国银行",@"兴业银行",@"中国农业银行",@"中信银行",@"中国光大银行",@"浦发银行"];
    [self.cardTypeTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cardTypeCell"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardTypeCell" forIndexPath:indexPath];
    NSString *imageIndex = [NSString stringWithFormat:@"bank%ld",(long)indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageIndex];
    cell.textLabel.text = self.bankNameArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selectedBank = self.bankNameArray[indexPath.row];
    NSString *selctedID = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    NSUserDefaults *defa =[NSUserDefaults standardUserDefaults];
    [defa setObject:selectedBank forKey:@"selectedBack"];
    [defa setObject:selctedID forKey:@"selectedID"];
    [defa synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
