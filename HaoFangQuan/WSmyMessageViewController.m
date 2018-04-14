//
//  WSmyMessageViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSmyMessageViewController.h"
#import "MyMessageTableCell.h"
#import "MuseHeader.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "myMessageModel.h"
@interface WSmyMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSMutableArray *messageTableData;
@end

@implementation WSmyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self receiveMyNewsFromServer];
    [self.myMessageTableView registerNib:[UINib nibWithNibName:@"MyMessageTableCell" bundle:nil] forCellReuseIdentifier:@"myMessageCell"];
    self.myMessageTableView.tableFooterView = [[UIView alloc]init];
}

-(void)receiveMyNewsFromServer{
    [MBProgressHUD showMessage:@"拼命加载中..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken,@"pageNum":@"1",@"pageSize":@"10"};
    NSString *ipString = myMessage;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        //NSLog(@"我的消息msg%@",statusDict[@"msg"]);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"我的消息msg%@",statusDict[@"msg"]);
            //NSLog(@"我的消息list%@",statusDict[@"messageList"]);
            NSArray *tempArray = statusDict[@"messageList"];
            self.messageTableData = [NSMutableArray array];
            if (tempArray.count>0) {
                self.noRView.hidden = YES;
            }else{
                self.noRView.hidden = NO;
            }
            for (NSDictionary *dic in tempArray) {
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    myMessageModel *model = [[myMessageModel alloc]init];
                    model.ID = [NSString stringWithFormat:@"%@",dic[@"id"]];
                    model.author = [NSString stringWithFormat:@"%@",dic[@"author"]];
                    model.time = [NSString stringWithFormat:@"%@",dic[@"time"]];
                    model.content = [NSString stringWithFormat:@"%@",dic[@"content"]];
                    model.isViewed = [NSString stringWithFormat:@"%@",dic[@"isviewed"]];
                    [self.messageTableData addObject:model];
                }
            }
            [self.myMessageTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
        [MBProgressHUD hideHUD];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageTableData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyMessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myMessageCell" forIndexPath:indexPath];
    myMessageModel *model = self.messageTableData[indexPath.row];
    cell.authorLabel.text = model.author;
    cell.timeLabel.text = model.time;
    cell.contentLabel.text = model.content;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    myMessageModel *currentModel = self.messageTableData[indexPath.row];
    [self.messageTableData removeObjectAtIndex:indexPath.row];
    [self.myMessageTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    //发送删除信息到服务器
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken,@"id":currentModel.ID};
    NSString *ipString = delMyMessage;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        //NSLog(@"我的消息msg%@",statusDict[@"msg"]);
        if ([result isEqualToString:@"0"]) {
            NSLog(@"我的消息msg%@",statusDict[@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
        [MBProgressHUD hideHUD];
    }];
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
