//
//  WSWoDeYinHangKaViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/4.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSWoDeYinHangKaViewController.h"
#import "WoDeYinHangKaTableViewCell.h"
#import "allMyCardsModel.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
@interface WSWoDeYinHangKaViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSMutableArray *allCardsData;
@end
#define houseSelected 1
#define houseUnSelected 0
@implementation WSWoDeYinHangKaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self receiveMyBankCardInfoFromServer];
    [self.cardTableView registerNib:[UINib nibWithNibName:@"WoDeYinHangKaTableViewCell" bundle:nil] forCellReuseIdentifier:@"woDeYinHangKaCell"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self receiveMyBankCardInfoFromServer];
}
-(void)receiveMyBankCardInfoFromServer{
    [MBProgressHUD showMessage:@"正在拼命加载..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken,@"pageNum":@"0",@"pageSize":@"20"};
    NSString *ipString = allMyCard;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"cardList%@",statusDict[@"cardList"]);
            NSArray *tempArray = statusDict[@"cardList"];
            if (tempArray.count >0) {
                self.allCardsData = [NSMutableArray array];
                for (NSDictionary *dic in tempArray) {
                    allMyCardsModel *model = [[allMyCardsModel alloc]init];
                    model.cardID = dic[@"id"];
                    model.bankID = dic[@"bankid"];
                    model.bankName = dic[@"bank"];
                    model.cardTailNum = dic[@"cardTailNum"];
                    model.cardOwer = dic[@"desc"];
                    [self.allCardsData addObject:model];
                    //NSLog(@"savedBankID%@",model.bankID);
                }
                [self.cardTableView reloadData];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allCardsData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WoDeYinHangKaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"woDeYinHangKaCell" forIndexPath:indexPath];
    allMyCardsModel *currentModel = self.allCardsData[indexPath.row];
    cell.bankNameLabel.text = currentModel.bankName;
    cell.cardTailNumLabel.text = currentModel.cardTailNum;
    int imageIndex = [currentModel.bankID intValue];
    cell.bankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bank%d",imageIndex-1]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WoDeYinHangKaTableViewCell *cell =(WoDeYinHangKaTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectedIndex == houseUnSelected) {
        cell.selectedButton.selected = YES;
        cell.selectedIndex = houseSelected;
    }else{
        cell.selectedButton.selected = NO;
        cell.selectedIndex = houseUnSelected;
    }
    //[self.delegate woDeYinHangKaDidChooseCardWithName:cell.bankNameLabel.text image:nil andWeiHao:cell.cardTailNumLabel.text];
    allMyCardsModel *currentModel = self.allCardsData[indexPath.row];
    [self.delegate woDeYinHangKaDidChooseCardWithName:currentModel.bankName image:nil andWeiHao:currentModel.cardTailNum andBankID:currentModel.bankID andCardID:currentModel.cardID];
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
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
- (IBAction)jumpToAddCardPage:(id)sender {
}
@end
