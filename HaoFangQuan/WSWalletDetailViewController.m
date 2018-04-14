//
//  WSWalletDetailViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/6/11.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSWalletDetailViewController.h"
#import "WalletDetailTableViewCell.h"
#import "WalletDetailModel.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
@interface WSWalletDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(assign,nonatomic)int chooseSatatus;
@property(strong,nonatomic)NSMutableArray *walletDetaiData;
@property (weak, nonatomic) IBOutlet UIView *noDataDisplayView;
@property(strong,nonatomic)NSMutableArray *allDataArray;
@end

@implementation WSWalletDetailViewController
#define chooseStatusDown 0
#define chooseStatusUp 1
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self receiveWalletDetailInfo];
    [self setUpAppearance];
}
-(void)receiveWalletDetailInfo{
    [MBProgressHUD showMessage:@"正在拼命加载..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *ipString = GetWalletDetail;
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    NSDictionary *para = @{@"tokenId":userLoginToken,@"type":@"",@"pageNum":@"0",@"pageSize":@"100"};
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        //NSLog(@"msg%@",statusDict[@"msg"]);
        //NSLog(@"钱包明细%@",statusDict[@"list"]);
        //NSLog(@"code%@",statusDict[@"verifyCode"]);
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        if ([result isEqualToString:@"0"]) {
            NSArray *rootArray = statusDict[@"list"];
            if (rootArray.count>0) {
                //self.walletDetaiData = [NSMutableArray array];
                self.allDataArray = [NSMutableArray array];
                for (NSDictionary *dic in rootArray) {
                    WalletDetailModel *model = [[WalletDetailModel alloc]init];
                    model.name = dic[@"name"];
                    model.time = dic[@"time"];
                    model.type = [NSString stringWithFormat:@"%@",dic[@"type"]];
                    model.money = dic[@"money"];
                    [self.allDataArray addObject:model];
                }
                self.walletDetaiData = [self.allDataArray mutableCopy];
                if (self.walletDetaiData.count>0) {
                    self.noDataDisplayView.hidden = YES;
                    [self.walletDetailTableView reloadData];
                }else{
                    self.noDataDisplayView.hidden = NO;
                }
            }
        }else{
            [MBProgressHUD showError:statusDict[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}
#define typeButtonHeight 40
-(void)setUpAppearance{
    [self.walletDetailTableView registerNib:[UINib nibWithNibName:@"WalletDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"walletDetailCell"];
     self.chooseSatatus = chooseStatusUp;
    for (int i = 0; i<3; i++) {
        UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        typeButton.frame = CGRectMake(0, 20 +i*typeButtonHeight, self.selceteBackView.bounds.size.width, typeButtonHeight);
        //typeButton.titleLabel.textColor = [UIColor whiteColor];
        [typeButton setTintColor:[UIColor whiteColor]];
        switch (i) {
            case 0:
                [typeButton setTitle:@"分红" forState:UIControlStateNormal];
                [typeButton addTarget:self action:@selector(didChooseEarnMoneyByEmployed:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                [typeButton setTitle:@"返现金" forState:UIControlStateNormal];
                [typeButton addTarget:self action:@selector(didChooseEarnMooneyByShare:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2:
                [typeButton setTitle:@"提现" forState:UIControlStateNormal];
                [typeButton addTarget:self action:@selector(didChooseTiXian:) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                break;
        }
        [self.selceteBackView addSubview:typeButton];
    }
    self.walletDetailTableView.tableFooterView = [[UIView alloc]init];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.walletDetaiData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"walletDetailCell" forIndexPath:indexPath];
    WalletDetailModel *model = self.walletDetaiData[indexPath.row];
    cell.nameLabel.text = model.name;
    cell.moneyLabel.text = model.money;
    cell.timeLabel.text = model.time;
    int typeIndex = [model.type intValue];
    //NSLog(@"type%@",model.type);
    switch (typeIndex) {
        case 0:
            cell.typeLabel.text = @"分红";
            break;
        case 1:
            cell.typeLabel.text = @"返现金";
            break;
        case 2:
            cell.typeLabel.text = @"注册送现金";
            break;
        case 3:
            cell.typeLabel.text = @"分红提现";
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
//选择显示转佣金
-(void)didChooseEarnMoneyByEmployed :(UIButton*)sender{
    self.selceteBackView.hidden = YES;
    self.chooseStateIndexButton.selected = NO;
    self.chooseSatatus = chooseStatusUp;
    //显示赚佣金数据
    NSMutableArray *tempArray = [NSMutableArray array];
    for (WalletDetailModel *model in self.allDataArray) {
        if ([model.type isEqualToString:@"0"]) {
            [tempArray addObject:model];
        }
    }
    self.walletDetaiData = [tempArray mutableCopy];
    if (self.walletDetaiData.count>0) {
        self.noDataDisplayView.hidden = YES;
    }else{
        self.noDataDisplayView.hidden = NO;
    }
    [self.walletDetailTableView reloadData];
}
//选择显示分享返现
-(void)didChooseEarnMooneyByShare :(UIButton*)sender{
    self.selceteBackView.hidden = YES;
    self.chooseStateIndexButton.selected = NO;
    self.chooseSatatus = chooseStatusUp;
    //显示分享返现数据
    NSMutableArray *tempArray = [NSMutableArray array];
    for (WalletDetailModel *model in self.allDataArray) {
        if ([model.type isEqualToString:@"2"]||[model.type isEqualToString:@"1"]) {
            [tempArray addObject:model];
        }
    }
    self.walletDetaiData = [tempArray mutableCopy];
    if (self.walletDetaiData.count>0) {
        self.noDataDisplayView.hidden = YES;
    }else{
        self.noDataDisplayView.hidden = NO;
    }
    [self.walletDetailTableView reloadData];
}
-(void)didChooseTiXian :(UIButton*)sender{
    self.selceteBackView.hidden = YES;
    self.chooseStateIndexButton.selected = NO;
    self.chooseSatatus = chooseStatusUp;
    //显示提现数据
    NSMutableArray *tempArray = [NSMutableArray array];
    for (WalletDetailModel *model in self.allDataArray) {
        if ([model.type isEqualToString:@"3"]) {
            [tempArray addObject:model];
        }
    }
    self.walletDetaiData = [tempArray mutableCopy];
    if (self.walletDetaiData.count>0) {
        self.noDataDisplayView.hidden = YES;
    }else{
        self.noDataDisplayView.hidden = NO;
    }
    [self.walletDetailTableView reloadData];
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

- (IBAction)changeType:(id)sender {
    if (self.chooseSatatus == chooseStatusDown) {
        self.selceteBackView.hidden = YES;
        self.chooseStateIndexButton.selected = NO;
        self.chooseSatatus = chooseStatusUp;
    }else{
        self.selceteBackView.hidden = NO;
        self.chooseStateIndexButton.selected = YES;
        self.chooseSatatus = chooseStatusDown;
    }

}
@end
