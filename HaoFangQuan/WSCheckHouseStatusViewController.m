//
//  WSCheckHouseStatusViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSCheckHouseStatusViewController.h"
#import "GouFangZhuangTaiTableViewCell.h"
#import "WSCheckStatusDetailViewController.h"
@interface WSCheckHouseStatusViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation WSCheckHouseStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.houseStatusTabelView registerNib:[UINib nibWithNibName:@"GouFangZhuangTaiTableViewCell" bundle:nil] forCellReuseIdentifier:@"gouFangZhangTaiCell"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GouFangZhuangTaiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gouFangZhangTaiCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 37;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WSCheckStatusDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailStatusVC"];
    [self.navigationController showViewController:detailVC sender:nil];
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
