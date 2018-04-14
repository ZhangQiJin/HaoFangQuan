//
//  WSFirstPageViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/27.
//  Copyright (c) 2015年 Muse. All rights reserved.

#import "WSFirstPageViewController.h"
#import "FangYuanTableCell.h"
#import "WSrootViewController.h"
#import "areaModel.h"
//#import "WSXianShiTeHuiViewController.h"
#import "WSMySharingViewController.h"
#import "WSTuiJianGouFangViewController.h"
#import "chooseHouseModel.h"
#import "WSLoginViewController.h"

#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MuseHeader.h"
#import "UIImageView+WebCache.h"
#import "houseSourceModel.h"
//#import "WSNewestHouseViewController.h"
#import "WSHouseDetailViewController.h"
#import "MJRefresh.h"
@interface WSFirstPageViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate>
@property(strong,nonatomic)UITableView *fangYuanTabelView;

@property(assign,nonatomic)NSUInteger areaChooseState;

@property(strong,nonatomic)UIView *pickBackView;
@property(strong,nonatomic)UIPickerView *pickView;
@property(strong,nonatomic)NSMutableArray *areaData;

@property(strong,nonatomic)NSArray *cityArray;
@property(copy,nonatomic)NSString *selectedArea;

@property(strong,nonatomic)NSMutableArray *haoFangDataArray;

@property(strong,nonatomic)UIPageControl *pageControl;
@property(strong,nonatomic)NSTimer *adTimer;
@property(strong,nonatomic)NSMutableArray *adDataArray;
@property(strong,nonatomic)NSMutableArray *houseListArray;
@property(assign,nonatomic)int currentPage;
@end

#define STATUS_DOWN 0
#define STATUS_UP 1
@implementation WSFirstPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self receiveAllCityFromServer];
    //[self receiveHaoFangDataFromServer];
    [self SETUpAppearance];
    self.areaChooseState = STATUS_DOWN;
    self.currentPage = 0;
}
//获取城市数据
-(void)receiveAllCityFromServer{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *ipString = receiveAllCityData;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        //NSLog(@"msg%@",statusDict[@"msg"]);
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        NSLog(@"rootDic=%@",statusDict);
        NSLog(@"msg=%@",statusDict[@"msg"]);
        //NSLog(@"ret%@",result);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"allCity%@",statusDict[@"province"]);
            NSArray *allProvince = statusDict[@"province"];
            if (allProvince.count>0) {
                self.areaData = [NSMutableArray array];
                for (NSDictionary *provinceDic in allProvince) {
                    areaModel *model = [[areaModel alloc]init];
                    model.provinceName = provinceDic[@"name"];
                    NSArray *cityArray = provinceDic[@"city"];
                    model.subAreasArray = [cityArray mutableCopy];
                    [self.areaData addObject:model];
                }
            }
            [self.pickView reloadAllComponents];
        }else{
            [MBProgressHUD showError:statusDict[@"msg"]];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}
//获取好房数据
-(void)receiveHaoFangDataFromServer{
    //[MBProgressHUD showMessage:@"正在拼命加载..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    //NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSString *userLoginToken = @"1db52007515dfce48024806728eab6a5";
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"pageNum":@"0",@"pageSize":@"10",@"filterArea":self.currentCityNameLabel.text};
    NSString *ipString = loadFirstPageData;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        //NSLog(@"msg%@",statusDict[@"msg"]);
        //[MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        //NSLog(@"adImage%@",statusDict[@"banner"]);
        //NSLog(@"houseList%@",statusDict[@"list"]);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"allCity%@",statusDict[@"province"]);
            NSArray *allAdArray = statusDict[@"banner"];
            if (allAdArray.count>0) {
                self.adDataArray = [NSMutableArray array];
                for (NSDictionary *adDic in allAdArray) {
                    NSString *adImageUrl =adDic[@"imgUrl"];
                    [self.adDataArray addObject:adImageUrl];
                }
                [self refreshAdScrollView];
            }
            NSArray *allListArray = statusDict[@"list"];
            if (allListArray.count>0) {
                self.noDataDisplayView.hidden = YES;
                self.houseListArray = [NSMutableArray array];
                for (NSDictionary *houseDic in allListArray) {
                    houseSourceModel *model = [[houseSourceModel alloc]init];
                    model.houseArea = houseDic[@"area"];
                    model.housecity = houseDic[@"city"];
                    model.houseDesc = houseDic[@"desc"];
                    model.houseGroup = houseDic[@"group"];
                    model.houseID = houseDic[@"id"];
                    model.houseImageUrl = houseDic[@"imgUrl"];
                    model.houseName = houseDic[@"name"];
                    model.housePrice = houseDic[@"price"];
                    model.houseMoney =[NSString stringWithFormat:@"%@元",houseDic[@"money"]];
                    [self.houseListArray addObject:model];
                }
                [self.fangYuanTabelView reloadData];
            }else{
                self.noDataDisplayView.hidden = NO;
            }
        }else{
            [MBProgressHUD showError:statusDict[@"msg"]];
        }
        [self.fangYuanTabelView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}
-(void)SETUpAppearance{
    self.navigationController.navigationBarHidden = YES;
    self.mainScrollView.contentSize  =CGSizeMake(0, self.mainScrollView.bounds.size.height+150);
    self.mainScrollView.bounces = NO;
    self.fangYuanTabelView = [[UITableView alloc]initWithFrame:self.functionPadView.bounds style:UITableViewStylePlain];
    self.fangYuanTabelView.delegate = self;
    self.fangYuanTabelView.dataSource = self;
    self.fangYuanTabelView.showsVerticalScrollIndicator = NO;
    [self.functionPadView addSubview:self.fangYuanTabelView];
    [self.fangYuanTabelView registerNib:[UINib nibWithNibName:@"FangYuanTableCell" bundle:nil] forCellReuseIdentifier:@"fangYuanCell"];
    //[self.mainScrollView addSubview:self.fangYuanTabelView];
    
    self.pickBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, 280)];
    //self.pickBackView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:242.0/255 alpha:1.0];
    self.pickBackView.backgroundColor = [UIColor lightGrayColor];
    self.pickBackView.hidden = YES;
    [self.view addSubview:self.pickBackView];
    
    self.pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 10, self.pickBackView.bounds.size.width, self.pickBackView.bounds.size.height - 20)];
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    [self.pickBackView addSubview:self.pickView];
    
    UIButton *confirmSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmSelectButton.frame = CGRectMake(self.pickView.bounds.size.width - 50, 5, 40, 30);
    [confirmSelectButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmSelectButton addTarget:self action:@selector(confrimSelectedArea:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickBackView addSubview:confirmSelectButton];
    
    UIButton *cancelSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelSelectButton.frame = CGRectMake(10, 5, 40, 30);
    [cancelSelectButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelSelectButton addTarget:self action:@selector(cancelSelectedArea:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickBackView addSubview:cancelSelectButton];
    
    self.adScrollView.delegate = self;
    
    self.youJiangYaoYueButton.layer.cornerRadius = 5.0f;
    self.youJiangYaoYueButton.layer.masksToBounds = YES;
    [self.fangYuanTabelView addHeaderWithTarget:self action:@selector(loadNewHouseData)];
    [self.fangYuanTabelView addFooterWithTarget:self action:@selector(loadMoreData)];
}
-(void)loadNewHouseData{
    [self receiveHaoFangDataFromServer];
}
-(void)loadMoreData{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    //NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSString *userLoginToken = @"1db52007515dfce48024806728eab6a5";
    //NSLog(@"loginToken%@",userLoginToken);
    self.currentPage ++;
    NSString *pageStr =[NSString stringWithFormat:@"%d",self.currentPage];
    NSDictionary *para = @{@"pageNum":pageStr,@"pageSize":@"10",@"filterArea":self.currentCityNameLabel.text};
    NSString *ipString = loadFirstPageData;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        //NSLog(@"msg%@",statusDict[@"msg"]);
        //[MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        //NSLog(@"adImage%@",statusDict[@"banner"]);
        //NSLog(@"houseList%@",statusDict[@"list"]);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"allCity%@",statusDict[@"province"]);
            //NSArray *allAdArray = statusDict[@"banner"];
//            if (allAdArray.count>0) {
//                self.adDataArray = [NSMutableArray array];
//                for (NSDictionary *adDic in allAdArray) {
//                    NSString *adImageUrl =adDic[@"imgUrl"];
//                    [self.adDataArray addObject:adImageUrl];
//                }
//                [self refreshAdScrollView];
//            }
            NSArray *allListArray = statusDict[@"list"];
            if (allListArray.count>0) {
                self.noDataDisplayView.hidden = YES;
                //self.houseListArray = [NSMutableArray array];
                for (NSDictionary *houseDic in allListArray) {
                    houseSourceModel *model = [[houseSourceModel alloc]init];
                    model.houseArea = houseDic[@"area"];
                    model.housecity = houseDic[@"city"];
                    model.houseDesc = houseDic[@"desc"];
                    model.houseGroup = houseDic[@"group"];
                    model.houseID = houseDic[@"id"];
                    model.houseImageUrl = houseDic[@"imgUrl"];
                    model.houseName = houseDic[@"name"];
                    model.housePrice = houseDic[@"price"];
                    model.houseMoney =[NSString stringWithFormat:@"%@元",houseDic[@"money"]];
                    [self.houseListArray addObject:model];
                }
                [self.fangYuanTabelView reloadData];
            }else{
                self.noDataDisplayView.hidden = NO;
                self.currentPage --;
            }
        }else{
            [MBProgressHUD showError:statusDict[@"msg"]];
        }
        [self.fangYuanTabelView footerEndRefreshing];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}
//刷新广告栏数据
#define imageHeadUrl @"http://120.25.153.217"
-(void)refreshAdScrollView{
    self.adScrollView.contentSize = CGSizeMake(self.view.frame.size.width*self.adDataArray.count, self.adScrollView.bounds.size.height);
    for (int i = 0; i<self.adDataArray.count; i++) {
        UIImageView *adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.bounds.size.width, self.adScrollView.bounds.size.height)];
        //ShouYeAdModel *model = self.adArray[i];
        NSString *currentUrl = self.adDataArray[i];
        adImageView.userInteractionEnabled = YES;
        NSString *imageUrl = [imageHeadUrl stringByAppendingString:currentUrl];
        //NSLog(@"%@",imageUrl);
        imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [adImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"LOGO"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
        [self.adScrollView addSubview:adImageView];
    }
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 15, self.adScrollView.bounds.origin.y + self.adScrollView.bounds.size.height-20, 30, 20)];
    self.pageControl.numberOfPages = self.adDataArray.count;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:36.0/255 green:157.0/255 blue:13.0/255 alpha:1.0];
    [self.mainScrollView addSubview:self.pageControl];
    if (self.adDataArray.count>1) {
        self.pageControl.hidden = NO;
        //[self timerOn];
    }else{
        self.pageControl.hidden = YES;
    }
}
//广告栏相关方法
-(void)imgPlay{
    int i =(int) self.pageControl.currentPage;
    if (i==4-1) {
        i=-1;
    }
    i++;
    [self.adScrollView setContentOffset:CGPointMake(i*self.adScrollView.frame.size.width, 0) animated:YES];
}

-(void)timerOn{
    self.adTimer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(imgPlay) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.adTimer forMode:NSRunLoopCommonModes];
}
-(void)timerOff{
    [self.adTimer invalidate];
    self.adTimer=nil;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.adScrollView) {
        self.pageControl.currentPage=(self.adScrollView.frame.size.width*0.5+self.adScrollView.contentOffset.x)/self.adScrollView.frame.size.width;
    }else if (scrollView == self.mainScrollView){
        float currentOffSet = scrollView.contentOffset.y;
        if (currentOffSet>=300) {
            self.mainScrollView.contentOffset = CGPointMake(0, 300);
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     //self.mainScrollView.contentSize  =CGSizeMake(self.mainScrollView.bounds.size.width, self.mainScrollView.bounds.size.height + 400);
}


#pragma UITABLE_DELEGATE_AND_DATASOURCE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.houseListArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FangYuanTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fangYuanCell" forIndexPath:indexPath];
    houseSourceModel *model = self.houseListArray[indexPath.row];
    //NSLog(@"houseName%@",model.houseName);
    NSString *imageUrl = [imageHeadUrl stringByAppendingString:model.houseImageUrl];
    imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@",imageUrl);
    [cell.houseImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"LOGO"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    cell.houseNameLabel.text = model.houseName;
    cell.houseLocationLabel.text = [NSString stringWithFormat:@"%@ %@",model.housecity,model.houseArea];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@/㎡",model.housePrice];//model.housePrice;
    cell.housePromoteLabel.text = model.houseDesc;
    [cell.recomendButton addTarget:self action:@selector(jumpToRecomendedPage:) forControlEvents:UIControlEventTouchUpInside];
    cell.recomendButton.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WSrootViewController*tabBarVC =self.navigationController.childViewControllers[0];
    tabBarVC.selectedBackView.hidden = YES;
    houseSourceModel *model = self.houseListArray[indexPath.row];
    WSHouseDetailViewController *houseDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"houseDetailVC"];
    houseDetailVC.passedHouseModel = model;
    houseDetailVC.houseID = model.houseID;
    houseDetailVC.houseName = model.houseName;
    [self.navigationController showViewController:houseDetailVC sender:nil];
}
-(void)jumpToRecomendedPage :(UIButton*)sender{
    BOOL loginState = [[NSUserDefaults standardUserDefaults]boolForKey:@"whetherlogin"];
    if (loginState) {
        houseSourceModel *model = self.houseListArray[sender.tag];
        WSTuiJianGouFangViewController *tuiJianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tuiJianGouFangVC"];
        chooseHouseModel *passedModel = [[chooseHouseModel alloc]init];
        passedModel.name = model.houseName;
        passedModel.desc = model.houseDesc;
        passedModel.price = model.housePrice;
        passedModel.imgUrl = model.houseImageUrl;
        passedModel.city = model.housecity;
        passedModel.area = model.houseArea;
        passedModel.houseID = model.houseID;
        passedModel.money = model.houseMoney;
        NSArray *passedHouse = @[passedModel];
        tuiJianVC.disPlayData = [passedHouse mutableCopy];
        [self.navigationController showViewController:tuiJianVC sender:nil];
    }else{
        WSLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self showDetailViewController:navi sender:nil];
    }
}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

#define ProvinceComponent 0
#define CityComponent 1

#pragma PickViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    areaModel *model = self.areaData[0];
    if (component == ProvinceComponent) {
        return self.areaData.count;
    }else{
        if (self.cityArray.count>0) {
            return self.cityArray.count;
        }else{
            return  model.subAreasArray.count;
        }
    }
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //areaModel *model = self.areaData[row];
    if (component == ProvinceComponent) {
        areaModel *model = self.areaData[row];
        return model.provinceName;
    }else{
        if (self.cityArray.count>0) {
            return self.cityArray[row];
        }else{
            areaModel *model = self.areaData[0];
            //return model.subAreasArray[0];
            return model.subAreasArray[row];
        }
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == ProvinceComponent) {
        areaModel *model = self.areaData[row];
        self.cityArray = [model.subAreasArray copy];
        [self.pickView reloadComponent:CityComponent];
        self.selectedArea = model.subAreasArray[0];
        //[self.pickView selectRow:0 inComponent:CityComponent animated:YES];
    }else{
        self.selectedArea = [NSString stringWithFormat:@"%@",self.cityArray[row]];
    }
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    [defa setObject:self.selectedArea forKey:@"selectedCity"];
    [defa synchronize];
}

-(void)confrimSelectedArea :(UIButton *)sender{
    UIImage *downImage = [UIImage imageNamed:@"shouYeYellowDown.png"];
    //NSLog(@"selectedArea%@",self.selectedArea);
    if (self.selectedArea!= nil) {
        self.currentCityNameLabel.text = self.selectedArea;
        [self receiveHaoFangDataFromServer];
    }
    self.pickBackView.hidden = YES;
    //self.currentCityNameLabel.text = self.selectedArea;
    self.areaSelectIndexImageView.image = downImage;
    self.areaChooseState = STATUS_DOWN;
    [self receiveHaoFangDataFromServer];
}

-(void)cancelSelectedArea :(UIButton *)sender{
    UIImage *downImage = [UIImage imageNamed:@"shouYeYellowDown.png"];
    self.pickBackView.hidden = YES;
    self.areaSelectIndexImageView.image = downImage;
    self.areaChooseState = STATUS_DOWN;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    WSrootViewController *
//}


#pragma ScrollViewDelegate
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    float currentOffSet = scrollView.contentOffset.y;
//    NSLog(@"current%.2lf",currentOffSet);
//    NSLog(@"total%.2lf",self.mainScrollView.bounds.size.height + 200);
//    if (currentOffSet>300) {
//        self.mainScrollView.contentOffset = CGPointMake(0, 300);
////        self.mainScrollView.scrollEnabled = NO;
////        self.fangYuanTabelView.scrollEnabled = YES;
//    }
//}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView == self.mainScrollView) {
//        float currentOffSet = scrollView.contentOffset.y;
//        NSLog(@"current%.2lf",currentOffSet);
//        //NSLog(@"total%.2lf",self.mainScrollView.bounds.size.height + 200);
//        if (currentOffSet >= 300) {
//            self.mainScrollView.contentOffset = CGPointMake(0, 300);
//            //self.mainScrollView.scrollEnabled = NO;
//            //self.mainScrollView.bounces = NO;
//            //[self.fangYuanTabelView becomeFirstResponder];
//            //self.fangYuanTabelView.scrollEnabled = YES;
//        }
//    }else if (scrollView == self.fangYuanTabelView){
//        float currentOffSet = scrollView.contentOffset.y;
//        if (currentOffSet <= 0) {
//            //self.mainScrollView.contentOffset = CGPointMake(0, 300);
//            //self.mainScrollView.scrollEnabled = YES;
//            //self.fangYuanTabelView.scrollEnabled = NO;
//            [self.mainScrollView becomeFirstResponder];
//        }
//    }
//}
- (IBAction)chooseArea:(id)sender {
    //WSrootViewController *rootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"rootTabBarVC"];
    UIImage *downImage = [UIImage imageNamed:@"shouYeYellowDown.png"];
    UIImage *upImage = [UIImage imageNamed:@"teHuiUpImage.png"];
    if (self.areaChooseState == STATUS_DOWN) {
        self.areaSelectIndexImageView.image = upImage;
        self.areaChooseState = STATUS_UP;
        self.pickBackView.hidden = NO;
    }else{
        self.areaSelectIndexImageView.image = downImage;
        self.areaChooseState = STATUS_DOWN;
        self.pickBackView.hidden = YES;
    }
}

//- (IBAction)jumpToXinFangPage:(id)sender {
//    UINavigationController *naiv = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    WSrootViewController*tabBarVC =(WSrootViewController*) naiv.childViewControllers[0];
//    tabBarVC.selectedBackView.hidden = YES;
//    WSNewestHouseViewController *newestHouseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newestHouseVC"];
//    [self.navigationController pushViewController:newestHouseVC animated:YES];
//}

//- (IBAction)jumpToXianShiTeHuiPage:(id)sender {
//    UINavigationController *naiv = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    WSrootViewController*tabBarVC =(WSrootViewController*) naiv.childViewControllers[0];
//    tabBarVC.selectedBackView.hidden = YES;
//    WSXianShiTeHuiViewController *houseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"xianShiTeHuiVC"];
//    houseVC.title = @"限时特惠";
//    houseVC.pushIndex = @"4";
//    houseVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:houseVC animated:YES];
//}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    WSrootViewController*tabBarVC =self.navigationController.childViewControllers[0];
    tabBarVC.selectedBackView.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    WSrootViewController*tabBarVC =self.navigationController.childViewControllers[0];
    tabBarVC.selectedBackView.hidden = NO;
    
    NSString *selectedCity = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCity"];
    if (selectedCity != nil) {
        self.currentCityNameLabel.text = selectedCity;
    }
    [self receiveHaoFangDataFromServer];
}
- (IBAction)jumpToYouJiangYaoYue:(id)sender {
    WSrootViewController*tabBarVC =self.navigationController.childViewControllers[0];
    tabBarVC.selectedBackView.hidden = YES;
    WSMySharingViewController *youJiangFenXiangVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mySharingVC"];
    [self.navigationController showViewController:youJiangFenXiangVC sender:nil];
}
- (IBAction)jumpToZhuanYongJin:(id)sender {
    BOOL loginState = [[NSUserDefaults standardUserDefaults]boolForKey:@"whetherlogin"];
    if (loginState) {
        WSTuiJianGouFangViewController *tuiJianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tuiJianGouFangVC"];
        [self.navigationController showViewController:tuiJianVC sender:nil];
    }else{
        WSLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self showDetailViewController:navi sender:nil];
    }
}
@end
