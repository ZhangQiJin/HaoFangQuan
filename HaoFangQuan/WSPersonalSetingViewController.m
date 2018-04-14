//
//  WSPersonalSetingViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSPersonalSetingViewController.h"
#import "WSChangeNameViewController.h"
#import "WSChangePhoneViewController.h"
#import "areaModel.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "WSrootViewController.h"
@interface WSPersonalSetingViewController ()<WSChangeNameDelegate,WSChangePhoneDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property(strong,nonatomic)UIView *pickBackView;
@property(strong,nonatomic)UIPickerView *cityPickView;
@property(strong,nonatomic)NSMutableArray *areaData;
@property(strong,nonatomic)NSArray *cityArray;
@property(copy,nonatomic)NSString *selectedCity;
@property(copy,nonatomic)NSString *selectedProvince;
@property(assign,nonatomic)NSUInteger areaChooseState;
@property(assign,nonatomic)int cityIndex;
@property(strong,nonatomic)UIButton *confirmSelectAreaButton;
@end

@implementation WSPersonalSetingViewController

#define STATUS_DOWN 0
#define STATUS_UP 1
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpAppearance];
    [self receiveCityData];
    self.cityIndex = 0;
}
-(void)setUpAppearance{
    self.pickBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, 150)];
    self.pickBackView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.pickBackView];
    self.pickBackView.hidden = YES;
    
    self.cityPickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 10, self.pickBackView.bounds.size.width, self.pickBackView.bounds.size.height)];
    self.cityPickView.delegate = self;
    self.cityPickView.dataSource = self;
    [self.pickBackView addSubview:self.cityPickView];
    
    self.confirmSelectAreaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmSelectAreaButton.frame = CGRectMake(self.cityPickView.bounds.size.width - 50, 5, 40, 30);
    [self.confirmSelectAreaButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmSelectAreaButton addTarget:self action:@selector(confrimSelectedArea:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmSelectAreaButton.hidden = YES;
    [self.pickBackView addSubview:self.confirmSelectAreaButton];
    
    UIButton *cancelSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelSelectButton.frame = CGRectMake(10, 5, 40, 30);
    [cancelSelectButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelSelectButton addTarget:self action:@selector(cancelSelectedArea:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickBackView addSubview:cancelSelectButton];
    
    self.nameLabel.text = self.passedName;
    self.phoneLabel.text = self.passedPhone;
    self.areaLabel.text = self.passedArea;
}
//
-(void)receiveCityData{
    self.areaData = [NSMutableArray array];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"allCities" ofType:@"plist"];
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
}
#define ProvinceComponent 0
#define CityComponent 1
#pragma pickViewDelegate
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
    self.confirmSelectAreaButton.hidden = NO;
    if (component == ProvinceComponent) {
        areaModel *model = self.areaData[row];
        self.cityArray = [model.subAreasArray copy];
        [self.cityPickView reloadComponent:CityComponent];
        self.selectedProvince = model.provinceName;
        self.selectedCity = model.subAreasArray[self.cityIndex];
        //[self.pickView selectRow:0 inComponent:CityComponent animated:YES];
    }else{
        self.selectedCity = [NSString stringWithFormat:@"%@",self.cityArray[row]];
        self.cityIndex =(int)row;
    }
}
-(void)confrimSelectedArea :(UIButton *)sender{
    //UIImage *downImage = [UIImage imageNamed:@"shouYeDown.png"];
    self.pickBackView.hidden = YES;
    //self.currentCityNameLabel.text = self.selectedArea;
    //self.areaSelectIndexImageView.image = downImage;
    //self.areaChooseState = STATUS_DOWN;
    if ((self.selectedProvince != nil)&&(self.selectedCity != nil)) {
        self.areaLabel.text = [self.selectedProvince stringByAppendingString:self.selectedCity];
        [self submitChagedArea];
    }
}
-(void)submitChagedArea{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken,@"province":self.selectedProvince,@"city":self.selectedCity};
    NSString *ipString = changeMyArea;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"msg%@",statusDict[@"msg"]);
            //[MBProgressHUD showSuccess:@"修改成功"];
//            NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
//            [defau setObject:self.nameTF.text forKey:@"userName"];
//            [defau synchronize];
//            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}
-(void)cancelSelectedArea :(UIButton *)sender{
    //UIImage *downImage = [UIImage imageNamed:@"shouYeDown.png"];
    self.pickBackView.hidden = YES;
    //self.areaSelectIndexImageView.image = downImage;
    //self.areaChooseState = STATUS_DOWN;
    self.phoneLabel.text = self.passedPhone;
    self.nameLabel.text = self.passedName;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userHeadImage"];
    if (data!= nil) {
        UIImage *headimage = [UIImage imageWithData:data];
        //NSLog(@"%@",headimage);
        //[self.loginButton setImage:headimage forState:UIControlStateNormal];
        self.samllHeadImageView.layer.cornerRadius = 22;
        self.samllHeadImageView.layer.masksToBounds = YES;
        self.samllHeadImageView.image = headimage;
    }
    //self.phoneLabel.text = self.passedPhone;
    //self.nameLabel.text = self.passedName;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"nameSegue"]) {
        WSChangeNameViewController *changeNameVC = segue.destinationViewController;
        changeNameVC.delegate = self;
        changeNameVC.passedName = self.nameLabel.text;
    }else if ([segue.identifier isEqualToString:@"phoneSegue"]){
        WSChangePhoneViewController *changePhoneVC = segue.destinationViewController;
        changePhoneVC.delegate = self;
        changePhoneVC.passedPhone = self.phoneLabel.text;
    }
//    WSrootViewController*tabBarVC =(WSrootViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    tabBarVC.selectedBackView.hidden = YES;
}

-(void)changeNameViewControllerFinishEditWithChangedName:(NSString *)string{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",string];
}
-(void)changePhoneViewControllerFinishEditWithChangedPhone:(NSString *)string{
    self.phoneLabel.text = string;
}
- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)chooseArea:(id)sender {
    if (self.areaChooseState == STATUS_DOWN) {
        self.areaChooseState = STATUS_UP;
        self.pickBackView.hidden = NO;
    }else{
        self.areaChooseState = STATUS_DOWN;
        self.pickBackView.hidden = YES;
    }
}

@end
