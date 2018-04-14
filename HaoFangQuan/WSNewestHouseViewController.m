//
//  WSNewestHouseViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/27.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSNewestHouseViewController.h"
#import "TeHuiTableViewCell.h"
#import "areaModel.h"
#import "houseSourceModel.h"
#import "chooseHouseModel.h"
#import "WSTuiJianGouFangViewController.h"
#import "WSHouseDetailViewController.h"
#import "WSrootViewController.h"
#import "WSLoginViewController.h"

#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
@interface WSNewestHouseViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property(assign,nonatomic)int changeAreaStatus;
@property(assign,nonatomic)int changeHouseTypeStatus;
//chooseArea
@property(strong,nonatomic)UIView *pickBackView;
@property(strong,nonatomic)UIPickerView *pickView;
@property(strong,nonatomic)NSMutableArray *areaData;
@property(strong,nonatomic)NSArray *cityArray;
@property(copy,nonatomic)NSString *selectedArea;
@property(copy,nonatomic)NSString *selectedHouseType;
@property(assign,nonatomic)int seletedIndex;

@property(strong,nonatomic)NSArray *houseTypeArray;
@property(strong,nonatomic)NSMutableArray *houseListArray;
@end

@implementation WSNewestHouseViewController
#define chooseStatusDown 0
#define chooseStatusUp 1

#define chooseAreaIndex 2
#define chooseHouseTypeIndex 3
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self receiveDataFromServer];
    self.navigationController.navigationBarHidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.newestHouseTabelView registerNib:[UINib nibWithNibName:@"TeHuiTableViewCell" bundle:nil] forCellReuseIdentifier:@"teHuiCell"];
    self.changeAreaStatus = chooseStatusDown;
    self.changeHouseTypeStatus = chooseStatusDown;
    self.seletedIndex = chooseAreaIndex;
    [self creatAreaData];
    [self setUpAppearance];
}
-(void)receiveDataFromServer{
    [MBProgressHUD showMessage:@"正在拼命加载..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    //NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSString *userLoginToken = @"1db52007515dfce48024806728eab6a5";
    NSDictionary *para = @{@"tokenId":userLoginToken};
    NSString *ipString = loadFirstPageData;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        //NSLog(@"msg%@",statusDict[@"msg"]);
        [MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        //NSLog(@"adImage%@",statusDict[@"banner"]);
        //NSLog(@"houseList%@",statusDict[@"list"]);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"allCity%@",statusDict[@"province"]);
            NSArray *allAdArray = statusDict[@"banner"];
            if (allAdArray.count>0) {
//                self.adDataArray = [NSMutableArray array];
//                for (NSDictionary *adDic in allAdArray) {
//                    NSString *adImageUrl =adDic[@"imgUrl"];
//                    [self.adDataArray addObject:adImageUrl];
//                }
//                [self refreshAdScrollView];
            }
            NSArray *allListArray = statusDict[@"list"];
            if (allListArray.count>0) {
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
                    [self.houseListArray addObject:model];
                }
                [self.newestHouseTabelView reloadData];
            }
        }else{
            [MBProgressHUD showError:statusDict[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络连接后重试"];
    }];

}
-(void)setUpAppearance{
    self.pickBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 110, self.view.bounds.size.width, 200)];
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
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.houseListArray.count;
}
#define imageHeadUrl @"http://120.25.153.217"
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeHuiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teHuiCell" forIndexPath:indexPath];
    houseSourceModel *model = self.houseListArray[indexPath.row];
    NSString *imageUrl = [imageHeadUrl stringByAppendingString:model.houseImageUrl];
    imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@",imageUrl);
    [cell.teHuiImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"LOGO"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    cell.houseNameLabel.text = model.houseName;
    cell.houseLocationLabel.text = model.houseArea;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@/m2",model.housePrice];//model.housePrice;
    cell.housePromoteLabel.text = model.houseDesc;
    [cell.liJiTuiJianButton addTarget:self action:@selector(jumpToReconmendedPage:) forControlEvents:UIControlEventTouchUpInside];
    cell.liJiTuiJianButton.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    houseSourceModel *model = self.houseListArray[indexPath.row];
    WSHouseDetailViewController *houseDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"houseDetailVC"];
    houseDetailVC.houseID = model.houseID;
    houseDetailVC.houseName = model.houseName;
    [self.navigationController showViewController:houseDetailVC sender:nil];
}
-(void)jumpToReconmendedPage :(UIButton*)sender{
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
        NSArray *passedHouse = @[passedModel];
        tuiJianVC.disPlayData = [passedHouse mutableCopy];
        [self.navigationController showViewController:tuiJianVC sender:nil];
    }else{
        WSLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        //[self.navigationController showViewController:loginVC sender:nil];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:loginVC];
        //[self showViewController:navi sender:nil];
        [self showDetailViewController:navi sender:nil];
    }
}
#define ProvinceComponent 0
#define CityComponent 1

#pragma PickViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.seletedIndex == chooseAreaIndex) {
        return 2;
    }else{
        return 1;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.seletedIndex == chooseAreaIndex) {
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
    }else{
        return self.houseTypeArray.count;
    }
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //areaModel *model = self.areaData[row];
    if (self.seletedIndex == chooseAreaIndex) {
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
    }else{
        return self.houseTypeArray[row];
    }
    //    if (component == ProvinceComponent) {
    //        areaModel *model = self.areaData[row];
    //        return model.provinceName;
    //    }else{
    //        if (self.cityArray.count>0) {
    //            return self.cityArray[row];
    //        }else{
    //            areaModel *model = self.areaData[0];
    //            //return model.subAreasArray[0];
    //            return model.subAreasArray[row];
    //        }
    //    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.seletedIndex == chooseAreaIndex) {
        if (component == ProvinceComponent) {
            areaModel *model = self.areaData[row];
            self.cityArray = [model.subAreasArray copy];
            [self.pickView reloadComponent:CityComponent];
            self.selectedArea = model.subAreasArray[0];
            //[self.pickView selectRow:0 inComponent:CityComponent animated:YES];
        }else{
            self.selectedArea = [NSString stringWithFormat:@"%@",self.cityArray[row]];
        }
    }else{
        self.selectedHouseType = [NSString stringWithFormat:@"%@",self.houseTypeArray[row]];
    }
    //    if (component == ProvinceComponent) {
    //        areaModel *model = self.areaData[row];
    //        self.cityArray = [model.subAreasArray copy];
    //        [self.pickView reloadComponent:CityComponent];
    //        self.selectedArea = model.subAreasArray[0];
    //        //[self.pickView selectRow:0 inComponent:CityComponent animated:YES];
    //    }else{
    //        self.selectedArea = [NSString stringWithFormat:@"%@",self.cityArray[row]];
    //    }
}

-(void)confrimSelectedArea :(UIButton *)sender{
    self.pickBackView.hidden = YES;
    //self.currentCityNameLabel.text = self.selectedArea;
    //self.areaSelectIndexImageView.image = downImage;
    self.areaIndexButton.selected = NO;
    self.areaButton.selected = NO;
    self.houseTypeButton.selected = NO;
    self.houseTypeIndexButton.selected = NO;
    self.changeAreaStatus = chooseStatusDown;
    self.selectedButtonA.enabled = YES;
    self.selectedButtonB.enabled = YES;
}

-(void)cancelSelectedArea :(UIButton *)sender{
    //UIImage *downImage = [UIImage imageNamed:@"shouYeDown.png"];
    self.pickBackView.hidden = YES;
    self.areaIndexButton.selected = NO;
    self.areaButton.selected = NO;
    self.houseTypeButton.selected = NO;
    self.houseTypeIndexButton.selected = NO;
    self.changeAreaStatus = chooseStatusDown;
    self.houseTypeIndexButton.enabled = YES;
    self.areaIndexButton.enabled = YES;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)chooseArea:(id)sender {
    self.selectedButtonB.enabled = NO;
    self.seletedIndex = chooseAreaIndex;
    [self.pickView reloadAllComponents];
    if (self.changeAreaStatus == chooseStatusDown) {
        self.areaIndexButton.selected = YES;
        self.areaButton.selected = YES;
        self.changeAreaStatus = chooseStatusUp;
        self.pickBackView.hidden = NO;
    }else{
        self.areaIndexButton.selected = NO;
        self.areaButton.selected = NO;
        self.changeAreaStatus = chooseStatusDown;
        self.pickBackView.hidden = YES;
        self.selectedButtonB.enabled = YES;
    }
}

- (IBAction)changeHouseType:(id)sender {
    self.selectedButtonA.enabled = NO;
    self.seletedIndex = chooseHouseTypeIndex;
    [self.pickView reloadAllComponents];
    if (self.changeHouseTypeStatus == chooseStatusDown) {
        self.houseTypeIndexButton.selected = YES;
        self.houseTypeButton.selected = YES;
        self.changeHouseTypeStatus = chooseStatusUp;
        self.pickBackView.hidden = NO;
    }else{
        self.houseTypeIndexButton.selected = NO;
        self.houseTypeButton.selected = NO;
        self.changeHouseTypeStatus = chooseStatusDown;
        self.pickBackView.hidden = YES;
        self.selectedButtonA.enabled = YES;
    }
}
-(void)creatAreaData{
    self.areaData = [NSMutableArray array];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
    NSArray *rootArray = [NSArray arrayWithContentsOfFile:filePath];
    if (rootArray.count>0) {
        for (NSDictionary *dic in rootArray) {
            areaModel *model = [[areaModel alloc]init];
            model.provinceName = dic[@"state"];
            NSArray *tempArray = dic[@"cities"];
            if (tempArray.count>0) {
                for (NSDictionary *subDic in tempArray) {
                    NSString *cityName = subDic[@"city"];
                    [model.subAreasArray addObject:cityName];
                }
            }
            [self.areaData addObject:model];
        }
    }
    self.houseTypeArray = @[@"不限",@"住宅",@"商住",@"豪宅",@"别墅",@"商铺",];
}

- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
