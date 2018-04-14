//
//  WSSearchResultViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/6/9.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSSearchResultViewController.h"
#import "houseSourceModel.h"
#import "TeHuiTableViewCell.h"
#import "WSTuiJianGouFangViewController.h"
#import "chooseHouseModel.h"
#import "WSLoginViewController.h"
#import "WSHouseDetailViewController.h"

#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
@interface WSSearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSMutableArray *searchResultData;
@end

@implementation WSSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self receiveSearchResultFromServer];
    [self.searchResultTableView registerNib:[UINib nibWithNibName:@"TeHuiTableViewCell" bundle:nil] forCellReuseIdentifier:@"teHuiCell"];
}
-(void)receiveSearchResultFromServer{
    [MBProgressHUD showMessage:@"正在拼命加载"];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    //NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    NSString *userLoginToken = @"1db52007515dfce48024806728eab6a5";
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken,@"search":self.search,@"type":self.type,@"pageNum":@"0",@"pageSize":@"10"};
    NSString *ipString = houseSearch;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        //NSLog(@"msg%@",statusDict[@"msg"]);
        [MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        //NSLog(@"searchList%@",statusDict[@"list"]);
        if ([result isEqualToString:@"0"]) {
            NSArray *allHouseArray = statusDict[@"list"];
            if (allHouseArray.count>0) {
                self.noResultView.hidden = YES;
                self.searchResultTableView.hidden = NO;
                self.searchResultData = [NSMutableArray array];
                for (NSDictionary *houseDic in allHouseArray) {
                    houseSourceModel *model = [[houseSourceModel alloc]init];
                    model.houseArea = houseDic[@"area"];
                    model.housecity = houseDic[@"city"];
                    model.houseDesc = houseDic[@"desc"];
                    model.houseGroup = houseDic[@"group"];
                    model.houseID = [NSString stringWithFormat:@"%@",houseDic[@"id"]];
                    model.houseImageUrl = houseDic[@"imgUrl"];
                    model.houseName = houseDic[@"name"];
                    model.housePrice = houseDic[@"price"];
                    model.houseMoney =[NSString stringWithFormat:@"%@元",houseDic[@"money"]];
                    [self.searchResultData addObject:model];
                }
                [self.searchResultTableView reloadData];
            }
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:statusDict[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResultData.count;
}
#define imageHeadUrl @"http://120.25.153.217"
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeHuiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teHuiCell" forIndexPath:indexPath];
    houseSourceModel *model = self.searchResultData[indexPath.row];
    NSString *imageUrl = [imageHeadUrl stringByAppendingString:model.houseImageUrl];
    imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@",imageUrl);
    [cell.teHuiImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"LOGO"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    cell.houseNameLabel.text = model.houseName;
    cell.houseLocationLabel.text =[NSString stringWithFormat:@"%@ %@",model.housecity,model.houseArea];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",model.housePrice];
    cell.housePromoteLabel.text = model.houseDesc;
    cell.housePromoteLabel.text = model.houseMoney;
    //NSLog(@"group=%@",model.houseGroup);
    if ([model.houseGroup isEqualToString:@"1"]) {
        cell.huiImageView.hidden = NO;
    }
    cell.liJiTuiJianButton.tag = indexPath.row;
    [cell.liJiTuiJianButton addTarget:self action:@selector(jumpToRecomendedPage:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WSHouseDetailViewController *houseDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"houseDetailVC"];
    houseSourceModel *model = self.searchResultData[indexPath.row];
    houseDetailVC.passedHouseModel = model;
    houseDetailVC.houseID = model.houseID;
    houseDetailVC.houseName = model.houseName;
    [self.navigationController showViewController:houseDetailVC sender:nil];
}
-(void)jumpToRecomendedPage :(UIButton*)sender{
    BOOL loginState = [[NSUserDefaults standardUserDefaults]boolForKey:@"whetherlogin"];
    if (loginState) {
        houseSourceModel *model = self.searchResultData[sender.tag];
        WSTuiJianGouFangViewController *tuiJianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tuiJianGouFangVC"];
        chooseHouseModel *passedModel = [[chooseHouseModel alloc]init];
        passedModel.name = model.houseName;
        passedModel.desc = model.houseDesc;
        passedModel.price = [model.housePrice stringByReplacingOccurrencesOfString:@"/㎡" withString:@" "];
        passedModel.imgUrl = model.houseImageUrl;
        passedModel.city = model.housecity;
        passedModel.area = model.houseArea;
        passedModel.money = [NSString stringWithFormat:@"%@",model.houseMoney];
        passedModel.houseID = model.houseID;
        NSArray *passedHouse = @[passedModel];
        tuiJianVC.disPlayData = [passedHouse mutableCopy];
        [self.navigationController showViewController:tuiJianVC sender:nil];
    }else{
        WSLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self showDetailViewController:navi sender:nil];
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

- (IBAction)turnBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
