//
//  WSHouseDetailViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/6/9.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSHouseDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "TeHuiTableViewCell.h"
#import "WSTuiJianGouFangViewController.h"
#import "houseSourceModel.h"
#import "HMAnnotation.h"
#import "WSBannerDetailViewController.h"
#import "WSMoreDetailMapViewViewController.h"
#import "WSLoginViewController.h"
#import "detailImageModel.h"
#import "chooseHouseModel.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
@interface WSHouseDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{
    NSUInteger _collectionState;
}
@property(strong,nonatomic)NSMutableArray *houseImageArray;
@property (strong, nonatomic) UILabel *imageCoutLabel;
@property(strong,nonatomic)UIButton *collectionButton;
@property(strong,nonatomic)UIWebView *phoneCallWebView;
@property(strong,nonatomic)UITableView *houseNearByTableView;
@property(strong,nonatomic)NSMutableArray *houseNearByTabelData;

@property(assign,nonatomic)CGFloat houseLantitude;
@property(assign,nonatomic)CGFloat houseLontitude;
@property(copy,nonatomic)NSString *savedCollectionState;
@property(copy,nonatomic)NSString *isMarked;

@property(strong,nonatomic)UIView *houseNearByView;
@property(assign,nonatomic)int detailViewState;
@property(strong,nonatomic)UIView *houseDetailView;
@property(strong,nonatomic)UIButton *detailViewStateButton;
@property (weak, nonatomic) IBOutlet UILabel *yongJinLabel;
@property(copy,nonatomic)NSString *collectionCurrentState;
@property(strong,nonatomic)CLLocationManager *mgr;
@end

#define UnCollection 0
#define didCollection 1
#define DetailViewDown 2
#define DetailViewUp 3
@implementation WSHouseDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self receiveHouseDetailDataFromServer];
    //[self creatTempHouseImageArray];//临时创建房屋图片
    [self setUpAppearance];
    //[self refreshView];
    self.detailViewState = DetailViewUp;
    self.collectionCurrentState = @"unchanged";
}

-(void)receiveHouseDetailDataFromServer{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    NSString *loginToken = [NSString stringWithFormat:@"%@",userLoginToken];
    if ([userLoginToken isEqualToString:@"nil"]) {
        userLoginToken = @"";
    }
    //NSString *userLoginToken = @"1db52007515dfce48024806728eab6a5";
    NSDictionary *para = @{@"id":self.houseID,@"tokenId":loginToken};
    NSString *ipString = houseDetail;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        //NSLog(@"房屋详情msg%@",statusDict[@"msg"]);
        //NSLog(@"房屋详情%@",statusDict[@"roomInfo"]);
        //NSLog(@"房屋详情banner%@",statusDict[@"banner"]);
        
        NSArray *tempImageUrlArray = statusDict[@"banner"];
        if (tempImageUrlArray.count>0) {
            self.houseImageArray = [NSMutableArray array];
            for (NSDictionary *urlDic in tempImageUrlArray) {
                //NSString *urlStr = urlDic[@"imgUrl"];
                detailImageModel *model = [[detailImageModel alloc]init];
                model.desc = urlDic[@"desc"];
                model.imgUrl = urlDic[@"imgUrl"];
                model.type = urlDic[@"type"];
                [self.houseImageArray addObject:model];
            }
            [self refreshView];
        }
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        NSDictionary *houseInfoDic = statusDict[@"roomInfo"];
        if ([result isEqualToString:@"0"]) {
            self.isMarked = [NSString stringWithFormat:@"%@",houseInfoDic[@"marked"]];
            //_collectionState  = didCollection;
            if ([self.isMarked isEqualToString:@"1"]) {
                self.collectionButton.selected = YES;
            }
            self.houseNameLabel.text = [NSString stringWithFormat:@"%@",houseInfoDic[@"name"]];
            self.priceLabel.text = [NSString stringWithFormat:@"%@",houseInfoDic[@"price"]];
            self.descLabel.text = [NSString stringWithFormat:@"%@",houseInfoDic[@"desc"]];
            if ([self.passedHouseType isEqualToString:@"newHouse"]){
                self.openTimeLabel.text = [NSString stringWithFormat:@"开盘时间:%@",houseInfoDic[@"opentime"]];
            }else{
                self.openTimeLabel.text = [NSString stringWithFormat:@"活动时间:%@",houseInfoDic[@"activDate"]];
            }
            //NSLog(@"houseInfo=%@",houseInfoDic);
            NSString *yiChengJiao = houseInfoDic[@"bargain"];
            if ([yiChengJiao isKindOfClass:[NSNull class]]) {
                self.yiChengJiaoLabel.text = @"0";
            }else{
                self.yiChengJiaoLabel.text = [NSString stringWithFormat:@"%@",houseInfoDic[@"bargain"]];
            }
            NSString *yiTuiJian = houseInfoDic[@"recommend"];
            if ([yiTuiJian isKindOfClass:[NSNull class]]) {
                self.yiTuiJianLabel.text = @"0";
            }else{
                self.yiTuiJianLabel.text = [NSString stringWithFormat:@"%@",houseInfoDic[@"recommend"]];
            }
            NSString *yiYuYue = houseInfoDic[@"recommend"];
            if ([yiYuYue isKindOfClass:[NSNull class]]) {
                self.yiYuYueLabel.text = @"0";
            }else{
                self.yiYuYueLabel.text = [NSString stringWithFormat:@"%@",houseInfoDic[@"subscribe"]];
            }
            self.contactPhoneLabel.text = [NSString stringWithFormat:@"%@",houseInfoDic[@"phone"]];
            self.savedCollectionState = [NSString stringWithFormat:@"%@",houseInfoDic[@"marked"]];
            NSString *shengYuStr = [NSString stringWithFormat:@"%@天",houseInfoDic[@"residueDate"]];
            int restDay = [shengYuStr intValue];
            if (restDay>0) {
                self.shengYuTianShuLabel.text = [NSString stringWithFormat:@"剩余%@天",houseInfoDic[@"residueDate"]];
            }else{
                self.shengYuTianShuLabel.text = @"活动已结束";
            }
            self.yongJinLabel.text = [NSString stringWithFormat:@"￥%@起",houseInfoDic[@"commission"]];
            //楼盘详情
                for (int i = 0; i<6; i++) {
                    UILabel *flagLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, (i*30), 280, 32)];
                    flagLabel.font = [UIFont systemFontOfSize:13];
                    flagLabel.numberOfLines = 0;
                    [self.houseDetailView addSubview:flagLabel];
                    switch (i) {
                        case 0:
                            flagLabel.text =[NSString stringWithFormat:@"开盘时间: %@",houseInfoDic[@"opentime"]];
                            break;
                        case 1:
                            flagLabel.text = [NSString stringWithFormat:@"面积段: %@",houseInfoDic[@"houseArea"]];
                            break;
                        case 2:
                            flagLabel.text = [NSString stringWithFormat:@"物业类型: %@",houseInfoDic[@"houseType"]];
                            break;
                        case 3:
                            flagLabel.text = [NSString stringWithFormat:@"总套数: %@",houseInfoDic[@"planHouses"]];
                            break;
                        case 4:
                            flagLabel.text = [NSString stringWithFormat:@"开发商: %@",houseInfoDic[@"developers"]];
                            break;
                        case 5:
                            flagLabel.text = [NSString stringWithFormat:@"项目位置: %@",houseInfoDic[@"housesAddress"]];//@"物业费:";
                            break;
                        default:
                            break;
                    }
                }
            //经纬度
            NSDictionary *locationDic = statusDict[@"location"];
            NSString *latStr =[NSString stringWithFormat:@"%@",locationDic[@"latitude"]];
            NSString *logStr =[NSString stringWithFormat:@"%@",locationDic[@"longitude"]];
            if ((latStr.length>0) && (logStr.length>0)) {
                self.houseLantitude = [latStr floatValue];
                self.houseLontitude = [logStr floatValue];
            }
            //周边房屋table
            NSArray *houseNear = statusDict[@"list"];
            //NSLog(@"houseNearbyList%@",statusDict[@"list"]);
            if (houseNear.count>0) {
                self.houseNearByTabelData = [NSMutableArray array];
                for (NSDictionary *houseDic in houseNear) {
                    houseSourceModel *model = [[houseSourceModel alloc]init];
                    model.houseArea = [NSString stringWithFormat:@"%@",houseDic[@"area"]];
                    model.housecity = [NSString stringWithFormat:@"%@",houseDic[@"city"]];
                    model.houseDesc = [NSString stringWithFormat:@"%@",houseDic[@"desc"]];
                    model.houseGroup = [NSString stringWithFormat:@"%@",houseDic[@"group"]];//houseDic[@"group"];
                    model.houseID = [NSString stringWithFormat:@"%@",houseDic[@"id"]];//houseDic[@"id"];
                    model.houseImageUrl =[NSString stringWithFormat:@"%@",houseDic[@"imgUrl"]]; //houseDic[@"imgUrl"];
                    model.houseName = [NSString stringWithFormat:@"%@",houseDic[@"name"]];//houseDic[@"name"];
                    model.housePrice = [NSString stringWithFormat:@"%@",houseDic[@"price"]];
                    model.houseMoney = [NSString stringWithFormat:@"%@",houseDic[@"money"]];
                    [self.houseNearByTabelData addObject:model];
                }
                [self.houseNearByTableView reloadData];
            }
        }else{
            [MBProgressHUD showError:statusDict[@"msg"]];
        }
        //回到主线程刷新
        [self addTargetAnotation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
    //[self addTargetAnotation];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //NSString *upDateState = [[NSUserDefaults standardUserDefaults]valueForKey:@"collectionState"];
//    if ([self.savedCollectionState isEqualToString:@"1"]) {
//        self.collectionButton.selected = YES;
//        _collectionState  = didCollection;
//    }else{
//        self.collectionButton.selected = NO;
//        _collectionState  = UnCollection;
//    }
    
    if ([self.passedHouseType isEqualToString:@"newHouse"]) {
        self.huoDongShiJianlabel.text = @"开盘时间";
        self.shengYuTianShuLabel.hidden = YES;
        self.huiIconImageView.hidden = YES;
    }
}
#define HOUSE_DETAIL_HEIGHT 180
-(void)setUpAppearance{
    //self.houseNameLabel.text = self.houseName;
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.bounds.size.width, self.mainScrollView.bounds.size.height *2);
    self.mainScrollView.bounces = NO;
    self.liJiTuiJianButton.layer.borderWidth = 0.5;
    self.liJiTuiJianButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    //楼盘详情
    UIView *houseDetaiTextView = [[UIView alloc]initWithFrame:CGRectMake(0, self.referanceView.frame.origin.y + self.referanceView.frame.size.height +5, self.mainScrollView.bounds.size.width, 40)];
    houseDetaiTextView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayOrHideDetailTextView:)];
    [houseDetaiTextView addGestureRecognizer:tapGR];
    [self.mainScrollView addSubview:houseDetaiTextView];
    
    UILabel *houseTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 80, 20)];
    houseTextLabel.text = @"楼盘详情";
    houseTextLabel.font = [UIFont systemFontOfSize:13];
    houseTextLabel.textColor = [UIColor blackColor];
    [houseDetaiTextView addSubview:houseTextLabel];
    
    self.detailViewStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.detailViewStateButton.frame = CGRectMake(260, 5, 20, 20);
    UIImage *normalImage = [UIImage imageNamed:@"stateNormal"];
    UIImage *selectImage = [UIImage imageNamed:@"stateSelected"];
    [self.detailViewStateButton setImage:normalImage forState:UIControlStateNormal];
    [self.detailViewStateButton setImage:selectImage forState:UIControlStateSelected];
    self.detailViewStateButton.selected = YES;
    [houseDetaiTextView addSubview:self.detailViewStateButton];
    //楼盘详情view
    self.houseDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, houseDetaiTextView.frame.origin.y + houseDetaiTextView.frame.size.height, houseDetaiTextView.frame.size.width, HOUSE_DETAIL_HEIGHT)];
    self.houseDetailView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.houseDetailView];

    //周边楼盘
    self.houseNearByView = [[UIView alloc]initWithFrame:CGRectMake(0, houseDetaiTextView.frame.origin.y + houseDetaiTextView.frame.size.height +10, self.mainScrollView.bounds.size.width, 42)];
    self.houseNearByView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
    [self.mainScrollView addSubview:self.houseNearByView];
    
    UILabel *houseNearByLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 80, 20)];
    houseNearByLabel.text = @"周边楼盘";
    houseNearByLabel.font = [UIFont systemFontOfSize:13];
    houseNearByLabel.textColor = [UIColor blackColor];
    [self.houseNearByView addSubview:houseNearByLabel];
    
    self.houseNearByTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.houseNearByView.frame.origin.y + self.houseNearByView.frame.size.height+2, self.mainScrollView.bounds.size.width, 200) style:UITableViewStylePlain];
    self.houseNearByTableView.delegate = self;
    self.houseNearByTableView.dataSource = self;
    [self.houseNearByTableView registerNib:[UINib nibWithNibName:@"TeHuiTableViewCell" bundle:nil] forCellReuseIdentifier:@"teHuiCell"];
    [self.mainScrollView addSubview:self.houseNearByTableView];
    
    UITapGestureRecognizer *mapTapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToDetailMapView:)];
    [self.detailMapView addGestureRecognizer:mapTapGR];
    
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(self.houseLantitude, self.houseLontitude);
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
//    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
//    [self.detailMapView setRegion:region animated:YES];
//    self.detailMapView.mapType = MKMapTypeStandard;
//    self.detailMapView.userTrackingMode = MKUserTrackingModeFollow;
//    self.detailMapView.delegate = self;
    self.liJiTuiJianButton.layer.cornerRadius = 5;
    self.liJiTuiJianButton.layer.masksToBounds = YES;
    self.liJiTuiJianButton.layer.borderWidth = 0.5;
    self.liJiTuiJianButton.layer.borderColor = [[UIColor whiteColor]CGColor];
}

//
-(void)jumpToDetailMapView :(UITapGestureRecognizer*)tapGR{
    WSMoreDetailMapViewViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"moreDetailMapView"];
    detailVC.houseLantitude = self.houseLantitude;
    detailVC.houseLontitude = self.houseLontitude;
    [self.navigationController showViewController:detailVC sender:nil];
}

//展开收起楼盘详情
-(void)displayOrHideDetailTextView :(UITapGestureRecognizer*)tanGR{
    if (self.detailViewState == DetailViewUp) {
        //展开
        self.detailViewStateButton.selected = NO;
        self.houseNearByView.frame = CGRectMake(0, self.houseNearByView.frame.origin.y+HOUSE_DETAIL_HEIGHT, self.houseNearByView.frame.size.width, self.houseNearByView.frame.size.height);
        self.houseNearByTableView.frame = CGRectMake(0, self.houseNearByTableView.frame.origin.y+HOUSE_DETAIL_HEIGHT, self.houseNearByTableView.frame.size.width, self.houseNearByTableView.frame.size.height);
        self.detailViewState = DetailViewDown;
    }else{
        self.detailViewStateButton.selected = YES;
        self.houseNearByView.frame = CGRectMake(0, self.houseNearByView.frame.origin.y-HOUSE_DETAIL_HEIGHT, self.houseNearByView.frame.size.width, self.houseNearByView.frame.size.height);
        self.houseNearByTableView.frame = CGRectMake(0, self.houseNearByTableView.frame.origin.y-HOUSE_DETAIL_HEIGHT, self.houseNearByTableView.frame.size.width, self.houseNearByTableView.frame.size.height);
        self.detailViewState = DetailViewUp;
    }
}

//-(void)setUpHouseDetailViweWithData{
//    for (int i = 0; i<8; i++) {
//        UILabel *flagLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 5+(i*23), 100, 13)];
//        flagLabel.font = [UIFont systemFontOfSize:13];
//        [self.houseDetailView addSubview:flagLabel];
//        switch (i) {
//            case 0:
//                flagLabel.text = @"物业类型:";
//                break;
//            case 1:
//                flagLabel.text = @"项目位置:";
//                break;
//            case 2:
//                flagLabel.text = @"面积段:";
//                break;
//            case 3:
//                flagLabel.text = @"开盘时间:";
//                break;
//            case 4:
//                flagLabel.text = @"入住时间:";
//                break;
//            case 5:
//                flagLabel.text = @"物业费:";
//                break;
//            case 6:
//                flagLabel.text = @"售楼地址:";
//                break;
//            case 7:
//                flagLabel.text = @"开发商:";
//                break;
//            default:
//                break;
//        }
//    }
//}
#pragma zhouBianLouPanTable_delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.houseNearByTabelData.count;
}
#define imageHeadUrl @"http://120.25.153.217"
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeHuiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teHuiCell" forIndexPath:indexPath];
    houseSourceModel *model = self.houseNearByTabelData[indexPath.row];
    NSString *imageUrl = [imageHeadUrl stringByAppendingString:model.houseImageUrl];
    imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@",imageUrl);
    [cell.teHuiImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"LOGO"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    cell.houseNameLabel.text = model.houseName;
    cell.houseLocationLabel.text = [NSString stringWithFormat:@"%@ %@",model.housecity,model.houseArea];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",model.housePrice];
    cell.housePromoteLabel.text = [NSString stringWithFormat:@"%@元",model.houseMoney];
    cell.liJiTuiJianButton.tag = indexPath.row;
    [cell.liJiTuiJianButton addTarget:self action:@selector(recomendNearbyHouse:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}
-(void)recomendNearbyHouse :(UIButton*)sender{
    BOOL loginState = [[NSUserDefaults standardUserDefaults]boolForKey:@"whetherlogin"];
    if (loginState) {
        houseSourceModel *model = self.houseNearByTabelData[sender.tag];
        WSTuiJianGouFangViewController *tuiJianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tuiJianGouFangVC"];
        chooseHouseModel *passedModel = [[chooseHouseModel alloc]init];
        passedModel.name = model.houseName;
        passedModel.desc = model.houseDesc;
        passedModel.price = model.housePrice;
        passedModel.imgUrl = model.houseImageUrl;
        passedModel.city = model.housecity;
        passedModel.area = model.houseArea;
        passedModel.houseID = model.houseID;
        passedModel.money =[NSString stringWithFormat:@"%@元",model.houseMoney];
        NSArray *passedHouse = @[passedModel];
        tuiJianVC.disPlayData = [passedHouse mutableCopy];
        [self.navigationController showViewController:tuiJianVC sender:nil];
    }else{
        WSLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self showDetailViewController:navi sender:nil];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    houseSourceModel *model = self.houseNearByTabelData[indexPath.row];
    WSHouseDetailViewController *nextDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"houseDetailVC"];
    nextDetailVC.houseID = model.houseID;
    [self.navigationController showViewController:nextDetailVC sender:nil];
}

//根据数据刷新界面
#define imageHeadUrl @"http://120.25.153.217"
-(void)refreshView{
    self.houseImageScrollView.contentSize = CGSizeMake(self.houseImageArray.count *self.houseImageScrollView.bounds.size.width, self.houseImageScrollView.bounds.size.height);
    for (int i = 0; i<self.houseImageArray.count; i++) {
        UIImageView *houseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.houseImageScrollView.bounds.size.width, 0, self.houseImageScrollView.bounds.size.width, self.houseImageScrollView.bounds.size.height)];
        detailImageModel *model = self.houseImageArray[i];
        NSString *imageUrl = [imageHeadUrl stringByAppendingString:model.imgUrl];
        imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //NSLog(@"%@",imageUrl);
        [houseImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"LOGO"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
        //houseImageView.image = [UIImage imageNamed:self.houseImageArray[i]];
        [self.houseImageScrollView addSubview:houseImageView];
    }
    self.imageCoutLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 50, 135, 40, 18)];
    self.imageCoutLabel.textAlignment = NSTextAlignmentCenter;
    self.imageCoutLabel.backgroundColor = [UIColor darkGrayColor];
    self.imageCoutLabel.textColor = [UIColor whiteColor];
    self.imageCoutLabel.font = [UIFont systemFontOfSize:13];
    self.imageCoutLabel.text = [NSString stringWithFormat:@"1/%ld",(unsigned long)self.houseImageArray.count];
    [self.mainScrollView addSubview:self.imageCoutLabel];
    
    self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectionButton.frame = CGRectMake(self.imageCoutLabel.frame.origin.x, 10, 40, 30);
    UIImage *normalImage = [UIImage imageNamed:@"collectionNormal"];
    UIImage *selectImage = [UIImage imageNamed:@"collectionSelect"];
    [self.collectionButton setImage:normalImage forState:UIControlStateNormal];
    [self.collectionButton setImage:selectImage forState:UIControlStateSelected];
    [self.collectionButton addTarget:self action:@selector(delOrAddCollection:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:self.collectionButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma scrollView_delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.houseImageScrollView) {
        float currentOffSetX = scrollView.contentOffset.x;
        int currentPage = currentOffSetX / self.houseImageScrollView.bounds.size.width;
        self.imageCoutLabel.text = [NSString stringWithFormat:@"%d/%ld",(currentPage +1),(unsigned long)self.houseImageArray.count];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"bannerDetailSegue"]) {
        WSBannerDetailViewController *bannerDetailVC = segue.destinationViewController;
        bannerDetailVC.passedBannerArray = [self.houseImageArray copy];
        bannerDetailVC.passedName = self.houseName;
    }
}
- (IBAction)turnBack:(id)sender {
    //向server提交收藏信息
    NSString *currentState = self.savedCollectionState;//[[NSUserDefaults standardUserDefaults]valueForKey:@"collectionState"];
    //NSLog(@"AFcoolectionState%@",currentState);
    if (([currentState isEqualToString:@"1"])&&([self.collectionCurrentState isEqualToString:@"changed"])) {
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        mgr.requestSerializer=[AFJSONRequestSerializer serializer];
        NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
        //NSLog(@"loginToken%@",userLoginToken);
        NSDictionary *para = @{@"tokenId":userLoginToken,@"id":self.houseID};
        NSString *ipString = didCollectHouse;
        ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
            NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
            if ([result isEqualToString:@"0"]) {
                //NSLog(@"收藏msg%@",statusDict[@"msg"]);
                //NSLog(@"url%@",statusDict[@"url"]);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[MBProgressHUD showError:@"请检查网络连接后重试"];
        }];
    }else{
        //调取消收藏接口
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)delOrAddCollection :(UIButton*)sender{
    if (_collectionState == UnCollection) {
        //未收藏
        self.collectionButton.selected = YES;
        _collectionState = didCollection;
        [MBProgressHUD showSuccess:@"房源收藏成功"];
    }else{
        //已收藏
        self.collectionButton.selected = NO;
        _collectionState = UnCollection;
        [MBProgressHUD showSuccess:@"房源取消成功"];
    }
    self.collectionCurrentState = @"changed";
    self.savedCollectionState = [NSString stringWithFormat:@"%lu",(unsigned long)_collectionState];
    NSString *likeState = [NSString stringWithFormat:@"%lu",(unsigned long)_collectionState];
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    //[defau setInteger:_collectionState forKey:@"collectionState"];
    [defau setObject:likeState forKey:@"collectionState"];
    [defau synchronize];
}
//拨打电话
- (IBAction)xiangQingCallAction:(id)sender {
    NSString *telNum = self.contactPhoneLabel.text;
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telNum]];
    if ( !self.phoneCallWebView ) {
        self.phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [self.phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

- (IBAction)liJiTuiJianAction:(id)sender {
    BOOL loginState = [[NSUserDefaults standardUserDefaults]boolForKey:@"whetherlogin"];
    if (loginState) {
        //houseSourceModel *model = self.houseListArray[sender.tag];
        WSTuiJianGouFangViewController *tuiJianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tuiJianGouFangVC"];
        chooseHouseModel *passedModel = [[chooseHouseModel alloc]init];
        passedModel.name = self.passedHouseModel.houseName;
        passedModel.desc = self.passedHouseModel.houseDesc;
        passedModel.price = self.passedHouseModel.housePrice;
        passedModel.imgUrl = self.passedHouseModel.houseImageUrl;
        passedModel.city = self.passedHouseModel.housecity;
        //NSLog(@"city=%@",self.passedHouseModel.housecity);
        passedModel.area = self.passedHouseModel.houseArea;
        passedModel.houseID = self.passedHouseModel.houseID;
        passedModel.money = self.passedHouseModel.houseMoney;
        NSArray *passedHouse = @[passedModel];
        tuiJianVC.disPlayData = [passedHouse mutableCopy];
        [self.navigationController showViewController:tuiJianVC sender:nil];
    }else{
        WSLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self showDetailViewController:navi sender:nil];
    }
}

-(void)addTargetAnotation{
//    self.mgr = [[CLLocationManager alloc] init];
//    self.mgr.delegate=self;
//    if ([self.mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//        [self.mgr requestWhenInUseAuthorization];
//    }
//    [self.mgr requestAlwaysAuthorization];
    HMAnnotation *gzAnno = [[HMAnnotation alloc] init];
    CLLocationCoordinate2D codinate = CLLocationCoordinate2DMake(self.houseLantitude, self.houseLontitude);
    gzAnno.coordinate = codinate;
    gzAnno.title = @"房屋位置";
    //gzAnno.subtitle = gzPm.name;
    [self.detailMapView addAnnotation:gzAnno];
    CLLocationCoordinate2D center = codinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.detailMapView setRegion:region animated:YES];
    self.detailMapView.mapType = MKMapTypeStandard;
    //self.detailMapView.userTrackingMode = MKUserTrackingModeFollow;
    self.detailMapView.delegate = self;
}
- (IBAction)UMSharing:(id)sender {
    UIImage *iconImage = [UIImage imageNamed:@"80.png"];
    [UMSocialSnsService presentSnsIconSheetView:self
                            appKey:@"559ce95467e58e7bbc002184"
                                      shareText:@"发现一个不错的楼盘，点击下载app查看,下载地址http://www.haofangquan.com/index.php/home/wap/index.html"
                                     shareImage:iconImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,UMShareToEmail,nil]
                                       delegate:nil];
    [UMSocialData defaultData].extConfig.title = @"好房圈";
}
@end
