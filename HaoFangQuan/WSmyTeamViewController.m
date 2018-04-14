//
//  WSmyTeamViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSmyTeamViewController.h"
#import "MyTeamTableCell.h"
#import "WSCustomerListViewController.h"
#import "MuseHeader.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "myTeamModel.h"
@interface WSmyTeamViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSMutableArray *myTeamTableData;
@property(strong,nonatomic)UIWebView *phoneCallWebView;
@end

@implementation WSmyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self receiveTeamInfoFromServer];
    [self.myTeamTableView registerNib:[UINib nibWithNibName:@"MyTeamTableCell" bundle:nil] forCellReuseIdentifier:@"myTeamCell"];
    self.myTeamTableView.tableFooterView = [[UIView alloc]init];
}
-(void)receiveTeamInfoFromServer{
    [MBProgressHUD showMessage:@"拼命加载中..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken};
    NSString *ipString = myTeam;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        //NSLog(@"我的团队dic=%@",statusDict);
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        if ([result isEqualToString:@"0"]) {
           NSArray *tempArray = statusDict[@"teamList"];
            self.myTeamTableData = [NSMutableArray array];
            if (tempArray.count>0) {
                self.noDataView.hidden = YES;
                for (NSDictionary *dic in tempArray) {
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        myTeamModel *model = [[myTeamModel alloc]init];
                        model.ID = [NSString stringWithFormat:@"%@",dic[@"id"]];
                        model.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                        model.joinTime = [NSString stringWithFormat:@"%@",dic[@"joinTime"]];
                        model.phoneNum = [NSString stringWithFormat:@"%@",dic[@"phoneNum"]];
                        [self.myTeamTableData addObject:model];
                    }
                }
            }else{
                self.noDataView.hidden = NO;
            }
            [self.myTeamTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
        [MBProgressHUD hideHUD];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myTeamTableData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTeamTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myTeamCell" forIndexPath:indexPath];
    myTeamModel *model = self.myTeamTableData[indexPath.row];
    cell.teamerNameLabel.text = model.name;
    cell.joinTimeLabel.text = model.joinTime;
    cell.phoneNumLabel.text = model.phoneNum;
    [cell.callButton addTarget:self action:@selector(callCustomer:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    myTeamModel *model = self.myTeamTableData[indexPath.row];
    WSCustomerListViewController *customerListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"customerListViewController"];
    customerListVC.pasedTeamID =model.ID;
    [self.navigationController showViewController:customerListVC sender:nil];
}
-(void)callCustomer :(UIButton*)sender{
    MyTeamTableCell *cell =(MyTeamTableCell*) [[sender superview] superview];
    NSString *telNum = cell.phoneNumLabel.text;
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telNum]];
    if ( !self.phoneCallWebView ) {
        self.phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [self.phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
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
