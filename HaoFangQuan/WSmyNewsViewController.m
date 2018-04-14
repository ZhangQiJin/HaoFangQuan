//
//  WSmyNewsViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSmyNewsViewController.h"
#import "MyNewsTableCell.h"
#import "WSNewsDetailViewController.h"
#import "haoFangQuanNewsModel.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
@interface WSmyNewsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSMutableArray *ziXunTableData;
@end

@implementation WSmyNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self receiveHaoFangQuanNewsFromServer];
    [self.myNewsTableView registerNib:[UINib nibWithNibName:@"MyNewsTableCell" bundle:nil] forCellReuseIdentifier:@"myNewsCell"];
}
-(void)receiveHaoFangQuanNewsFromServer{
    [MBProgressHUD showMessage:@"正在拼命加载中..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    //NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"pageNum":@"0",@"pageSize":@"10"};
    NSString *ipString = haoFangQuanNews;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        NSLog(@"好房圈资讯msg%@",statusDict[@"msg"]);
        if ([result isEqualToString:@"0"]) {
            NSLog(@"好房圈资讯msg%@",statusDict[@"msg"]);
            NSLog(@"好房圈资讯newslist%@",statusDict[@"news"]);
            NSArray *tempArray = statusDict[@"news"];
            if (tempArray.count>0) {
                self.ziXunTableData = [NSMutableArray array];
                for (NSDictionary *dic in tempArray) {
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        haoFangQuanNewsModel *model = [[haoFangQuanNewsModel alloc]init];
                        model.newsID = dic[@"id"];
                        model.imgUrl = dic[@"imgUrl"];
                        model.title = dic[@"title"];
                        model.content = dic[@"content"];
                        model.time = dic[@"time"];
                        model.detailUrl = dic[@"url"];
                        [self.ziXunTableData addObject:model];
                    }
                    [self.myNewsTableView reloadData];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ziXunTableData.count;
}
#define imageHeadUrl @"http://120.25.153.217"
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyNewsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myNewsCell" forIndexPath:indexPath];
    haoFangQuanNewsModel *model = self.ziXunTableData[indexPath.row];
    //NSString *imageUrl = [imageHeadUrl stringByAppendingString:model.imgUrl];
    NSString *imageUrl = model.imgUrl;
    imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"moRen"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    cell.subjectLabel.text = model.title;
    cell.decLabel.text = model.content;
    cell.timeLabel.text = model.time;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WSNewsDetailViewController *newsDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsDetailVC"];
    haoFangQuanNewsModel *model = self.ziXunTableData[indexPath.row];
    newsDetailVC.passedDetailURL = model.detailUrl;
    newsDetailVC.passedTitle = model.title;
    [self.navigationController showViewController:newsDetailVC sender:nil];
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
