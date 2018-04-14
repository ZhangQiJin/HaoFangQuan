//
//  WSTiXianJiLuViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/4.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSTiXianJiLuViewController.h"
#import "tiXianRecordTableViewCell.h"
#import "tiXianRecordModel.h"
#import "tiXianSubDetailRecordModel.h"

#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
@interface WSTiXianJiLuViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSMutableArray *tiXianRecordData;
@property(strong,nonatomic)NSMutableArray *originalDataArray;
@end

@implementation WSTiXianJiLuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self receiveDataFromServer];
    [self setUpAppearance];
}
-(void)receiveDataFromServer{
    [MBProgressHUD showMessage:@"正在拼命加载中..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken,@"pageNum":@"0",@"pageSize":@"20"};
    NSString *ipString = userTiXianRecord;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"提现记录msg%@",statusDict[@"list"]);
            NSArray *rootArray = statusDict[@"list"];
            if (rootArray.count >0) {
                self.tiXianRecordData = [NSMutableArray array];
                for (NSDictionary *dic in rootArray) {
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        //tiXianRecordModel *recordModel = [[tiXianRecordModel alloc]init];
                        //recordModel.groupName = dic[@"group"];
                        //创建提现子model
                        tiXianSubDetailRecordModel *model = [[tiXianSubDetailRecordModel alloc]init];
                        model.recordID = dic[@"id"];
                        model.bankSign = dic[@"bankSign"];
                        model.detail = dic[@"detail"];
                        model.money = dic[@"money"];
                        model.time = dic[@"time"];
                        model.state = dic[@"state"];
                        model.groupName = dic[@"group"];
                    
                        if (self.tiXianRecordData.count == 0) {
                            tiXianRecordModel *recordModel = [[tiXianRecordModel alloc]init];
                            recordModel.groupName = model.groupName;
                            [recordModel.detailRecordsArray addObject:model];
                            [self.tiXianRecordData addObject:recordModel];
                        }else{
                            NSArray *tempArray = [self.tiXianRecordData copy];
                            for (tiXianRecordModel *currentMonthModel in tempArray) {
                                if ([currentMonthModel.groupName isEqualToString:model.groupName]) {
                                    [currentMonthModel.detailRecordsArray addObject:model];
                                }else{
                                    tiXianRecordModel *recordModel = [[tiXianRecordModel alloc]init];
                                    recordModel.groupName = model.groupName;
                                    [self.tiXianRecordData addObject:recordModel];
                                }
                            }
                        }
                    }
                }
            }
            [self.tiXianJiLuTabelView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
        [MBProgressHUD hideHUD];
    }];
}
-(void)setUpAppearance{
    [self.tiXianJiLuTabelView registerNib:[UINib nibWithNibName:@"tiXianRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"tiXianRecordCell"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tiXianRecordData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tiXianRecordModel *model = self.tiXianRecordData[section];
    return model.detailRecordsArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tiXianRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tiXianRecordCell" forIndexPath:indexPath];
    tiXianRecordModel *model = self.tiXianRecordData[indexPath.section];
    tiXianSubDetailRecordModel *currentModel = model.detailRecordsArray[indexPath.row];
    cell.detailLabel.text = currentModel.detail;
    cell.timeLabel.text = currentModel.time;
    cell.moneyLabel.text = currentModel.money;
    if ([currentModel.state isEqualToString:@"0"]) {
        cell.stateLabel.text = @"正在处理中...";
        cell.stateLabel.textColor = [UIColor greenColor];
    }else if ([currentModel.state isEqualToString:@"1"]){
        cell.stateLabel.text = @"交易成功";
    }else{
        cell.stateLabel.text = @"交易失败";
    }
    //NSString *bankImageName = [NSString stringWithFormat:@"bank%@",currentModel.recordID];
    int bankSing = [currentModel.bankSign intValue];
    NSString *bankImageName = [NSString stringWithFormat:@"bank%d",bankSing-1];
    cell.bankImageView.image = [UIImage imageNamed:bankImageName];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
