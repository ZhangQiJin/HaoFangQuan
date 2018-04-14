//
//  WSmyCustomerViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSmyCustomerViewController.h"
#import "MyCustomerTableCell.h"
#import "WSTuiJianGouFangViewController.h"
#import "WSCustomerInfoViewController.h"

#import "MuseHeader.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "myCustomerModel.h"
@interface WSmyCustomerViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSMutableArray *customerTabelData;
@property(strong,nonatomic)UIWebView *phoneCallWebView;
@end

@implementation WSmyCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self receiveCustomerDataFromServer];
    [self.myCustomerTabelView registerNib:[UINib nibWithNibName:@"MyCustomerTableCell" bundle:nil] forCellReuseIdentifier:@"myCustomerCell"];
    self.myCustomerTabelView.tableFooterView = [[UIView alloc]init];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self receiveCustomerDataFromServer];
}
-(void)receiveCustomerDataFromServer{
    [MBProgressHUD showMessage:@"拼命加载中..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken,@"pageNum":@"0",@"pageSize":@"10"};
    NSString *ipString = myCustomers;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        //NSLog(@"我的消息msg%@",statusDict[@"msg"]);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"我的客户msg%@",statusDict[@"msg"]);
            //NSLog(@"我的客户list%@",statusDict[@"list"]);
            NSArray *tempArray = statusDict[@"list"];
            self.customerTabelData = [NSMutableArray array];
            if (tempArray.count>0) {
                self.noResultView.hidden = YES;
                for (NSDictionary *dic in tempArray) {
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        myCustomerModel *model = [[myCustomerModel alloc]init];
                        model.ID = [NSString stringWithFormat:@"%@",dic[@"id"]];
                        model.imgUrl = [NSString stringWithFormat:@"%@",dic[@"portrait"]];
                        model.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                        model.purpose = [NSString stringWithFormat:@"%@",dic[@"purpose"]];
                        model.apartMent = [NSString stringWithFormat:@"%@",dic[@"apartment"]];
                        model.priceRange = [NSString stringWithFormat:@"%@",dic[@"priceRange"]];
                        model.phone = [NSString stringWithFormat:@"%@",dic[@"phone"]];
                        [self.customerTabelData addObject:model];
                    }
                }
            }else{
                self.noResultView.hidden = NO;
            }
            [self.myCustomerTabelView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
        [MBProgressHUD hideHUD];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.customerTabelData.count;
}
#define imageHeadUrl @"http://120.25.153.217"
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCustomerTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCustomerCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    myCustomerModel *model = self.customerTabelData[indexPath.row];
    NSString *imageUrl = nil;
    if (model.imgUrl != nil) {
        imageUrl = [imageHeadUrl stringByAppendingString:model.imgUrl];
    }else{
        imageUrl = imageHeadUrl;
    }
    imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@",imageUrl);
    [cell.customerHeadImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"aboutMeHeadDefau"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    cell.nameLabel.text = model.name;
    cell.phoneLabel.text = model.phone;
    cell.yiXiangFangWuLabel.text = model.apartMent;
    cell.priceRangeLabel.text = model.priceRange;
    [cell.liJiTuiJianButton addTarget:self action:@selector(LiJiTuiJian:) forControlEvents:UIControlEventTouchUpInside];
    [cell.callCustomerButton addTarget:self action:@selector(callCustomer:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
-(void)callCustomer :(UIButton*)sender{
    MyCustomerTableCell *cell =(MyCustomerTableCell*) [[sender superview] superview];
    
    NSString *telNum = cell.phoneLabel.text;
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telNum]];
    if ( !self.phoneCallWebView ) {
        self.phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [self.phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    myCustomerModel *currentModel = self.customerTabelData[indexPath.row];
    [self.customerTabelData removeObjectAtIndex:indexPath.row];
    [self.myCustomerTabelView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken,@"id":currentModel.ID};
    NSString *ipString = delCustomers;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        //NSLog(@"我的消息msg%@",statusDict[@"msg"]);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"我的客户msg%@",statusDict[@"msg"]);
            //NSLog(@"我的客户list%@",statusDict[@"list"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WSCustomerInfoViewController *customerInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"customerInfoVC"];
    customerInfoVC.passedModel = self.customerTabelData[indexPath.row];
    [self.navigationController showViewController:customerInfoVC sender:nil];
}
//立即推荐
-(void)LiJiTuiJian :(UIButton*)sender{
    WSTuiJianGouFangViewController *tuijianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tuiJianGouFangVC"];
    MyCustomerTableCell *cell =(MyCustomerTableCell*) [[sender superview] superview];
    tuijianVC.passedName = cell.nameLabel.text;
    tuijianVC.passedPhone = cell.phoneLabel.text;
    [self.navigationController showViewController:tuijianVC sender:nil];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
