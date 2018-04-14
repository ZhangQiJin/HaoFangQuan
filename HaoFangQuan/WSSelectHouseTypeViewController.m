//
//  WSSelectHouseTypeViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/29.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSSelectHouseTypeViewController.h"
#import "TuiJianXuanZeFangYuanTableViewCell.h"
#import "areaModel.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#define houseSelected 1
#define houseUnSelected 0
@interface WSSelectHouseTypeViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
//@property(assign,nonatomic)NSUInteger selectIndex;
//@property(assign,nonatomic)NSUInteger selcetCount;
@property(strong,nonatomic)NSMutableArray *allHouseData;

@property(assign,nonatomic)int changeAreaStatus;
@property(assign,nonatomic)int changeHouseTypeStatus;
@property(strong,nonatomic)UIView *pickBackView;
@property(strong,nonatomic)UIPickerView *pickView;
@property(strong,nonatomic)NSMutableArray *areaData;
@property(strong,nonatomic)NSArray *cityArray;
@property(copy,nonatomic)NSString *selectedArea;
@property(copy,nonatomic)NSString *selectedHouseType;
@property(assign,nonatomic)int seletedIndex;
@property(strong,nonatomic)NSArray *houseTypeArray;
@end

#define chooseStatusDown 0
#define chooseStatusUp 1

#define chooseAreaIndex 2
#define chooseHouseTypeIndex 3
@implementation WSSelectHouseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self receiveDefaultDataFromerServer];
    [self.houseTypeTableView registerNib:[UINib nibWithNibName:@"TuiJianXuanZeFangYuanTableViewCell" bundle:nil] forCellReuseIdentifier:@"tuiJianXuanZeCell"];
    //self.selectIndex = houseUnSelected;
    //self.selcetCount = 0;
    self.changeAreaStatus = chooseStatusDown;
    self.changeHouseTypeStatus = chooseStatusDown;
    self.seletedIndex = chooseAreaIndex;
    [self creatAreaData];
    [self setUpAppearance];
}

-(void)receiveDefaultDataFromerServer{
    [MBProgressHUD showMessage:@"正在拼命加载..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    //NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"filterArea":@"兰州",@"filterType":@"",@"pageNum":@"0",@"pageSize":@"15"};
    NSString *ipString = loadHaoFangQuanHouseData;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        //NSLog(@"msg%@",statusDict[@"msg"]);
        //[MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"houseList:%@",statusDict[@"list"]);
            NSArray *allHouseArray = statusDict[@"list"];
            if (allHouseArray.count>0) {
                self.allHouseData = [NSMutableArray array];
                for (NSDictionary *dic in allHouseArray) {
                    chooseHouseModel *model = [[chooseHouseModel alloc]init];
                    model.name = dic[@"name"];
                    model.desc = dic[@"desc"];
                    model.imgUrl = dic[@"imgUrl"];
                    model.price = dic[@"price"];
                    model.city = dic[@"city"];
                    model.area = dic[@"area"];
                    model.houseID = dic[@"id"];
                    model.money = dic[@"money"];
                    [self.allHouseData addObject:model];
                }
                [self.houseTypeTableView reloadData];
            }
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
    return self.allHouseData.count;
}
#define imageHeadUrl @"http://120.25.153.217"
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TuiJianXuanZeFangYuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tuiJianXuanZeCell" forIndexPath:indexPath];
    chooseHouseModel *model = self.allHouseData[indexPath.row];
    cell.houseNameLabel.text = model.name;
    if (model.money.length>1) {
    NSString *moneyStr = [NSString stringWithFormat:@"%@ 起",model.money];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:moneyStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(str.length-1,1)];
    //cell.descLabel.text = [NSString stringWithFormat:@"%@元",model.money];
    cell.descLabel.attributedText = str;
    }
    cell.priceLabel.text =[NSString stringWithFormat:@"%@/㎡",model.price];
    //NSLog(@"price=%@",model.price);
    cell.areaLabel.text = [NSString stringWithFormat:@"%@ %@",model.city,model.area];
    
    NSString *imageUrl = [imageHeadUrl stringByAppendingString:model.imgUrl];
    imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@",imageUrl);
    [cell.tuiJianHouseImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"LOGO"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    TuiJianXuanZeFangYuanTableViewCell *cell =(TuiJianXuanZeFangYuanTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
//    if (cell.selectedIndex == houseUnSelected) {
//        cell.selectedButton.selected = YES;
//        cell.selectedIndex = houseSelected;
//        //self.selcetCount ++;
//        //self.selectedCountLabel.text = [NSString stringWithFormat:@"(%lu)",self.selcetCount];
//    }else{
//        cell.selectedButton.selected = NO;
//        cell.selectedIndex = houseUnSelected;
//        self.selcetCount --;
//        self.selectedCountLabel.text = [NSString stringWithFormat:@"(%lu)",self.selcetCount];
//    }
    chooseHouseModel *model = self.allHouseData[indexPath.row];
    [self.delegate didSelectedDesierHouseModel:model];
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
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
    self.houseTypeArray = @[@"小户型公寓",@"社区公寓",@"别墅",@"酒店式公寓",@"商业",@"大平层"];
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
        //[self.areaButton setTitle:self.selectedArea forState:UIControlStateNormal];
    }else{
        self.selectedHouseType = [NSString stringWithFormat:@"%@",self.houseTypeArray[row]];
        //[self.houseTypeButton setTitle:self.selectedHouseType forState:UIControlStateNormal];
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
    if (self.seletedIndex == chooseAreaIndex) {
        [self.areaButton setTitle:self.selectedArea forState:UIControlStateNormal];
    }else{
        [self.houseTypeButton setTitle:self.selectedHouseType forState:UIControlStateNormal];
    }
    //加载当前地方房屋数据
    [MBProgressHUD showMessage:@"正在拼命加载..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    //NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    if (self.selectedArea.length==0) {
        self.selectedArea = @"兰州";
    }
    if(self.selectedHouseType.length == 0){
        self.selectedHouseType = @"";
    }
    NSDictionary *para = @{@"filterArea":self.selectedArea,@"filterType":self.selectedHouseType,@"pageNum":@"0",@"pageSize":@"15"};
    NSString *ipString = loadHaoFangQuanHouseData;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        //NSLog(@"msg%@",statusDict[@"msg"]);
        //[MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"houseList:%@",statusDict[@"list"]);
            NSArray *allHouseArray = statusDict[@"list"];
            self.allHouseData = [NSMutableArray array];
            if (allHouseArray.count>0) {
                for (NSDictionary *dic in allHouseArray) {
                    chooseHouseModel *model = [[chooseHouseModel alloc]init];
                    model.name = dic[@"name"];
                    model.desc = dic[@"desc"];
                    model.imgUrl = dic[@"imgUrl"];
                    model.price = dic[@"price"];
                    model.city = dic[@"city"];
                    model.area = dic[@"area"];
                    model.houseID = dic[@"id"];
                    model.money = dic[@"money"];
                    [self.allHouseData addObject:model];
                }
            }
            [self.houseTypeTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
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

- (IBAction)chooseArea:(id)sender{
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
- (IBAction)changeHouseType:(id)sender{
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

- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
