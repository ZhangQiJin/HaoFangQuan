//
//  WSCheckStatusDetailViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSCheckStatusDetailViewController.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "customerStatusModel.h"
@interface WSCheckStatusDetailViewController ()
@property(copy,nonatomic)NSString *purpers;
@property(copy,nonatomic)NSString *apartment;
@property(copy,nonatomic)NSString *priceRange;
@property(copy,nonatomic)NSString *houseTitle;

@property(strong,nonatomic)NSMutableArray *processArray;
@end

@implementation WSCheckStatusDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self receiveDataFromServer];
}
-(void)receiveDataFromServer{
    //[MBProgressHUD showMessage:@"拼命加载中..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken,@"id":self.passedID};
    NSString *ipString;
    if ([self.pushIndex isEqualToString:@"team"]){
        ipString = teamCustomerBuyState;
    }else{
        ipString = customerStateDetail;
    }
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        //[MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        //NSLog(@"我的消息msg%@",statusDict[@"msg"]);
        if ([result isEqualToString:@"0"]) {
            self.purpers = statusDict[@"purpose"];
            self.apartment = statusDict[@"apartment"];
            self.priceRange = statusDict[@"priceRange"];
            self.houseTitle = statusDict[@"title"];
            NSArray *tempArray = statusDict[@"process"];
            //NSLog(@"processArray=%@",tempArray);
            self.processArray = [NSMutableArray array];
            for (NSDictionary *dic in tempArray) {
                customerStatusModel *model = [[customerStatusModel alloc]init];
                model.status = dic[@"status"];
                model.date = dic[@"date"];
                model.time = [NSString stringWithFormat:@"%@%@",dic[@"date"],dic[@"time"]];
                model.state = [NSString stringWithFormat:@"%@",dic[@"state"]];
                if ([model.state isEqualToString:@"1"]) {
                    [self.processArray addObject:model];
                }
            }
            [self refreshDisplay];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
        //[MBProgressHUD hideHUD];
    }];
}
-(void)refreshDisplay{
    self.houseNameLabel.text = self.houseTitle;
    self.purpersLabel.text = self.purpers;
    self.apartmentLabel.text = self.apartment;
    self.priceRangeLabel.text = self.priceRange;
    
    if (self.processArray.count>0) {
        for (customerStatusModel *model in self.processArray) {
            int modelStatus = [model.status intValue];
            for (UIButton *currentButton in self.stateButtons) {
                if (currentButton.tag == (modelStatus+59)) {
                    currentButton.selected = YES;
                }
            }
            for (UILabel *currentLabel in self.stateTimeLabels)
            {
                if (currentLabel.tag == (modelStatus+69)) {
                    currentLabel.text = model.time;
                }
            }
        }
        for (int i = 0; i<self.processArray.count; i++) {
            UILabel *label = self.statusTextLabels[i];
            label.textColor = [UIColor colorWithRed:246.0/255 green:73.0/255 blue:118.0/255 alpha:1.0];
        }
    }
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
