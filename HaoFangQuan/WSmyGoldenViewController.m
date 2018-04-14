//
//  WSmyGoldenViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSmyGoldenViewController.h"
#import "MyGoldPinkTableCell.h"
#import "myGoldBeanListModle.h"
#import "WSWalletDetailViewController.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
@interface WSmyGoldenViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(copy,nonatomic)NSString *totalAvailabelGold;
@property(strong,nonatomic)NSMutableArray *allGoldData;

@property(strong,nonatomic)UIView *sucessAlertView;
@end

@implementation WSmyGoldenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self receiveAllMyGoldListFromServer];
    [self.goldenTableView registerNib:[UINib nibWithNibName:@"MyGoldPinkTableCell" bundle:nil] forCellReuseIdentifier:@"goldenCell"];
}

-(void)receiveAllMyGoldListFromServer{
    [MBProgressHUD showMessage:@"正在拼命加载..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken,@"pageNum":@"0",@"pageSize":@"10"};
    NSString *ipString = allMyGoldList;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        //NSLog(@"我的消息msg%@",statusDict[@"msg"]);
        if ([result isEqualToString:@"0"]) {
            self.totalGoldBeanLabel.text = [NSString stringWithFormat:@"%@",statusDict[@"totalGoldBean"]];
            self.sucessRecomendLabel.text = [NSString stringWithFormat:@"%@次",statusDict[@"suceRecomm"]];
            self.totalRecomendLabel.text = [NSString stringWithFormat:@"%@次",statusDict[@"totalRecomm"]];
            self.totalAvailabelGold = statusDict[@"useableGoldBean"];
            self.avalbelGoldLabel.text = statusDict[@"useableGoldBean"];
            //NSLog(@"我的金豆msg%@",statusDict[@"msg"]);
            //NSLog(@"我的金豆list%@",statusDict[@"houses"]);
            NSArray *tempArray = statusDict[@"list"];
            self.allGoldData = [NSMutableArray array];
            for (NSDictionary *dic in tempArray) {
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    myGoldBeanListModle *model = [[myGoldBeanListModle alloc]init];
                    model.shareTime = dic[@"shareTime"];
                    model.shareRes = dic[@"shareRes"];
                    model.shareCus = dic[@"shareCus"];
                    model.getGoldBean = dic[@"getGoldBean"];
                    [self.allGoldData addObject:model];
                }
            }
            [self.goldenTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
        [MBProgressHUD hideHUD];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allGoldData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyGoldPinkTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goldenCell" forIndexPath:indexPath];
    myGoldBeanListModle *model = self.allGoldData[indexPath.row];
    cell.shareTimeLabel.text = model.shareTime;
    cell.shareFromLabel.text = model.shareRes;
    cell.shareCustomerLabel.text = model.shareCus;
    cell.goldCountLabel.text = model.getGoldBean;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
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
-(void)textFieldDidEndEditing:(UITextField *)textField{
    float inputCount = [textField.text floatValue];
    float totalCount = [self.totalAvailabelGold floatValue];
    if (inputCount*100 > totalCount) {
        self.tiQuGoldCountTextField.text = @"";
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"输入数量不能超过金豆总数量，请确认后重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        NSString *inputStr = [NSString stringWithFormat:@"%.lf",inputCount*100];
        self.tiQuGoldCountTextField.text = inputStr;
    }
}
- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)receiveGoldBean:(id)sender {
    self.tiQuGoldCountTextField.text = @"";
    self.viewCoverButton.hidden = NO;
    self.goldTiQuBackView.hidden = NO;
}
- (IBAction)hideCoverViewButton:(id)sender {
    self.tiQuGoldCountTextField.text = @"";
    self.viewCoverButton.hidden = YES;
    self.goldTiQuBackView.hidden = YES;
}
- (IBAction)cancelTiQuGold:(id)sender {
    self.tiQuGoldCountTextField.text = @"";
    self.viewCoverButton.hidden = YES;
    self.goldTiQuBackView.hidden = YES;
}
- (IBAction)confirmTiQu:(id)sender {
    if (self.tiQuGoldCountTextField.text.length>0) {
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        mgr.requestSerializer=[AFJSONRequestSerializer serializer];
        NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
        //NSLog(@"loginToken%@",userLoginToken);
        float inputCount = [self.tiQuGoldCountTextField.text floatValue];
        NSString *inputCountStr = [NSString stringWithFormat:@"%.lf",inputCount];
        NSDictionary *para = @{@"tokenId":userLoginToken,@"exchangeGold":inputCountStr};
        NSString *ipString = getMyGoldBean;
        ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
            [MBProgressHUD hideHUD];
            NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
            //NSLog(@"ret%@",result);
            NSLog(@"提取金豆msg%@",statusDict[@"msg"]);
            if ([result isEqualToString:@"0"]) {
                self.sucessAlertView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, self.goldTiQuBackView.bounds.size.width, self.goldTiQuBackView.bounds.size.height - 100)];
                self.sucessAlertView.backgroundColor = [UIColor whiteColor];
                [self.goldTiQuBackView addSubview:self.sucessAlertView];
                
                UILabel *aletLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.sucessAlertView.bounds.size.width*0.5-50, 10, 100, 20)];
                aletLabel.font = [UIFont systemFontOfSize:14];
                aletLabel.text = @"金豆提取成功";
                aletLabel.textAlignment = NSTextAlignmentCenter;
                [self.sucessAlertView addSubview:aletLabel];
                
                UILabel *secAlertLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.sucessAlertView.bounds.size.width*0.5)-100, aletLabel.frame.origin.y +aletLabel.frame.size.height, 200, 20)];
                secAlertLabel.font = [UIFont systemFontOfSize:14];
                secAlertLabel.textAlignment = NSTextAlignmentCenter;
                
                NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"请在我的钱包中提取现金!"];
                NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@"钱包"].location);
                [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:redRange];
                [secAlertLabel setAttributedText:noteStr] ;
                [self.sucessAlertView addSubview:secAlertLabel];
                
                UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                closeButton.frame = CGRectMake(20, 90, (self.sucessAlertView.bounds.size.width-40) *0.5, 40);
                [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
                closeButton.titleLabel.textColor = [UIColor darkGrayColor];
                closeButton.backgroundColor = [UIColor lightGrayColor];
                [closeButton addTarget:self action:@selector(closeSucessAlertView:) forControlEvents:UIControlEventTouchUpInside];
                [self.sucessAlertView addSubview:closeButton];
                
                UIButton *enterWalletButton = [UIButton buttonWithType:UIButtonTypeCustom];
                enterWalletButton.frame = CGRectMake(closeButton.frame.origin.x + closeButton.frame.size.width, 90, (self.sucessAlertView.bounds.size.width-40) *0.5, 40);
                [enterWalletButton setTitle:@"进入钱包" forState:UIControlStateNormal];
                enterWalletButton.titleLabel.textColor = [UIColor whiteColor];
                 [enterWalletButton setBackgroundColor:[UIColor orangeColor]];
                [enterWalletButton addTarget:self action:@selector(enterMyWallet:) forControlEvents:UIControlEventTouchUpInside];
                [self.sucessAlertView addSubview:enterWalletButton];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[MBProgressHUD showError:@"请检查网络连接后重试"];
            [MBProgressHUD hideHUD];
        }];
    }
}
-(void)closeSucessAlertView :(UIButton*)sender{
    [self.sucessAlertView removeFromSuperview];
    self.viewCoverButton.hidden = YES;
    self.goldTiQuBackView.hidden = YES;
    self.tiQuGoldCountTextField.text = @"";
}
-(void)enterMyWallet :(UIButton*)sender{
    [self.sucessAlertView removeFromSuperview];
    self.viewCoverButton.hidden = YES;
    self.goldTiQuBackView.hidden = YES;
    WSWalletDetailViewController *walletVC = [self.storyboard instantiateViewControllerWithIdentifier:@"walletDetailVC"];
    [self.navigationController showViewController:walletVC sender:nil];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
