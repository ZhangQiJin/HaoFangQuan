//
//  WSmyCollectionViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSmyCollectionViewController.h"
#import "TeHuiTableViewCell.h"
#import "WSTuiJianGouFangViewController.h"
#import "WSHouseDetailViewController.h"
#import "chooseHouseModel.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
#import "myCollectHouseModel.h"
#import "UIImageView+WebCache.h"
@interface WSmyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSMutableArray *myCollectionTableData;
@end

@implementation WSmyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self receiveCollectHouseDataFromServer];
    // Do any additional setup after loading the view.
    [self.myCollectionTableView registerNib:[UINib nibWithNibName:@"TeHuiTableViewCell" bundle:nil] forCellReuseIdentifier:@"teHuiCell"];
    self.myCollectionTableView.tableFooterView = [[UIView alloc]init];
}
-(void)receiveCollectHouseDataFromServer{
    [MBProgressHUD showMessage:@"拼命加载中..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken};
    NSString *ipString = allCollect;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"我的收藏%@",statusDict);
        //NSLog(@"ret%@",result);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"我的收藏list%@",statusDict[@"houses"]);
            NSArray *tempArray = statusDict[@"houses"];
            if (tempArray.count>0) {
                self.noCollView.hidden = YES;
            }else{
                self.noCollView.hidden = NO;
            }
            self.collectionCountLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)tempArray.count];
            self.myCollectionTableData = [NSMutableArray array];
            for (NSDictionary *dic in tempArray) {
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    myCollectHouseModel *model = [[myCollectHouseModel alloc]init];
                    model.houseID = [NSString stringWithFormat:@"%@",dic[@"id"]];
                    model.imgUrl = [NSString stringWithFormat:@"%@",dic[@"imgUrl"]];
                    model.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                    model.price = [NSString stringWithFormat:@"%@",dic[@"price"]];
                    model.city = [NSString stringWithFormat:@"%@",dic[@"city"]];
                    model.area = [NSString stringWithFormat:@"%@",dic[@"area"]];
                    model.desc = [NSString stringWithFormat:@"%@",dic[@"desc"]];
                    model.group = [NSString stringWithFormat:@"%@",dic[@"group"]];
                    model.groupId = [NSString stringWithFormat:@"%@",dic[@"groupId"]];
                    model.money = [NSString stringWithFormat:@"%@元",dic[@"money"]];
                    [self.myCollectionTableData addObject:model];
                }
            }
            [self.myCollectionTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
        [MBProgressHUD hideHUD];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myCollectionTableData.count;
}
#define imageHeadUrl @"http://120.25.153.217"
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeHuiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teHuiCell" forIndexPath:indexPath];
    myCollectHouseModel *model = self.myCollectionTableData[indexPath.row];
    NSString *imageUrl = [imageHeadUrl stringByAppendingString:model.imgUrl];
    imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@",imageUrl);
    [cell.teHuiImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"LOGO"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    cell.houseNameLabel.text = model.name;
    cell.houseLocationLabel.text = [NSString stringWithFormat:@"%@ %@",model.city,model.area];
    cell.housePromoteLabel.text = [NSString stringWithFormat:@"%@",model.money];
    cell.priceLabel.text =[NSString stringWithFormat:@"%@/㎡",model.price];
    [cell.liJiTuiJianButton addTarget:self action:@selector(jumpToReconmendedPage:) forControlEvents:UIControlEventTouchUpInside];
    cell.liJiTuiJianButton.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    myCollectHouseModel *currentModel = self.myCollectionTableData[indexPath.row];
    [self.myCollectionTableData removeObjectAtIndex:indexPath.row];
    [self.myCollectionTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken,@"id":currentModel.houseID};
    NSString *ipString = didCollectHouse;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"收藏msg%@",statusDict[@"msg"]);
            //NSLog(@"url%@",statusDict[@"url"]);
            [MBProgressHUD showSuccess:statusDict[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
    self.collectionCountLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)self.myCollectionTableData.count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WSHouseDetailViewController *houseDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"houseDetailVC"];
    myCollectHouseModel *model = self.myCollectionTableData[indexPath.row];
    //chooseHouseModel *passedModel = [[chooseHouseModel alloc]init];
    houseDetailVC.passedHouseModel = [[houseSourceModel alloc]init];
    houseDetailVC.passedHouseModel.houseName = model.name;
    houseDetailVC.passedHouseModel.houseDesc = model.desc;
    houseDetailVC.passedHouseModel.housePrice = model.price;
    houseDetailVC.passedHouseModel.houseImageUrl = model.imgUrl;
    houseDetailVC.passedHouseModel.housecity = model.city;
    //NSLog(@"shouCangCity=%@",model.city);
    houseDetailVC.passedHouseModel.houseArea = model.area;
    houseDetailVC.passedHouseModel.houseMoney = model.money;
    //houseDetailVC.passedHouseModel = passedModel;
    houseDetailVC.houseID = model.houseID;
    //houseDetailVC.houseName = model.name;
    [self.navigationController showViewController:houseDetailVC sender:nil];
}
-(void)jumpToReconmendedPage :(UIButton*)sender{
    myCollectHouseModel *model = self.myCollectionTableData[sender.tag];
    WSTuiJianGouFangViewController *tuiJianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tuiJianGouFangVC"];
    chooseHouseModel *passedModel = [[chooseHouseModel alloc]init];
    passedModel.name = model.name;
    passedModel.desc = model.desc;
    passedModel.price = model.price;
    passedModel.imgUrl = model.imgUrl;
    passedModel.city = model.city;
    passedModel.area = model.area;
    passedModel.money = model.money;
    NSArray *passedHouse = @[model];
    tuiJianVC.disPlayData = [passedHouse mutableCopy];
    [self.navigationController showViewController:tuiJianVC sender:nil];
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
