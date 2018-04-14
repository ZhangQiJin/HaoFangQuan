//
//  WSTuiJianGouFangViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/29.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSTuiJianGouFangViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "WSSelectHouseTypeViewController.h"
#import "chooseHouseModel.h"
#import "TuiJianXuanZeFangYuanTableViewCell.h"
#import "WSmyCustomerViewController.h"
#import "UIImageView+WebCache.h"

#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
@interface WSTuiJianGouFangViewController ()<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,SelectedDesireHouseDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
//@property(strong,nonatomic)chooseHouseModel *displayModel;

@end

@implementation WSTuiJianGouFangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpAppearance];
}
-(void)setUpAppearance{
    [self.selectedHouseTabelView registerNib:[UINib nibWithNibName:@"TuiJianXuanZeFangYuanTableViewCell" bundle:nil] forCellReuseIdentifier:@"tuiJianXuanZeCell"];
    self.chooseContactButton.layer.cornerRadius = 8.0f;
    self.chooseContactButton.layer.masksToBounds = YES;
    self.selectedHouseTabelView.tableFooterView = [[UIView alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardDidShow) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoradDidHiden) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyBoardDidShow{
    [UIView animateWithDuration:0.1 animations:^{
        self.submitButton.frame = CGRectMake(0, 89, self.submitButton.bounds.size.width, self.submitButton.bounds.size.height);
    } completion:nil];
}
//-(void)keyBoradDidHiden{
//    [UIView animateWithDuration:1.0 animations:^{
//        self.submitButton.frame = CGRectMake(0, 342, self.submitButton.bounds.size.width, self.submitButton.bounds.size.height);
//    } completion:nil];
//}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.passedName != nil) {
        self.nameTF.text = self.passedName;
    }
    if (self.passedPhone != nil) {
        self.phoneTF.text = self.passedPhone;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.nameTF) {
        self.nameTFCancelButton.hidden = NO;
    }else{
        self.phoneTFCancelButton.hidden = NO;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.nameTF) {
        self.nameTFCancelButton.hidden = YES;
        if (textField.text.length<2||textField.text.length>8) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"姓名长度只能为2-8个字符,请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
            self.nameTF.text = @"";
        }
        if (![self isChinesecharacter:textField.text]) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"姓名只能为汉字,请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
            self.nameTF.text = @"";
        }
    }else if(textField == self.phoneTF){
        self.phoneTFCancelButton.hidden = YES;
        if (![self isMobileNumber:textField.text]) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"您输入的手机号码格式有误，请确认后再次输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
            self.phoneTF.text = @"";
        }
    }
}
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (BOOL)isChinesecharacter:(NSString *)string{
    NSString *regex = @"[\u4e00-\u9fa5][\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject: string];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneTF) {
        if (range.location<=11) {
            return YES;
        }else{
            return NO;
        }
    }else if (textField == self.nameTF){
        if (range.location<=7) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.1 animations:^{
        self.submitButton.frame = CGRectMake(0, 342, self.submitButton.bounds.size.width, self.submitButton.bounds.size.height);
    } completion:nil];
    [self.view endEditing:YES];
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
- (IBAction)deleteTextFieldContent:(id)sender {
    UIButton *button = sender;
    if (button.tag == 5) {
        self.nameTF.text = @"";
    }else{
        self.phoneTF.text = @"";
    }
}
- (IBAction)choosePhoneContact:(id)sender {
    ABPeoplePickerNavigationController *ppnc = [[ABPeoplePickerNavigationController alloc]init];
    ppnc.peoplePickerDelegate = self;
    [self presentViewController:ppnc animated:YES completion:nil];
}
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person{
    //获取姓名
    NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
    if (lastName.length>0) {
        if (firstName.length>0) {
            self.nameTF.text = [lastName stringByAppendingString:firstName];
        }else{
            self.nameTF.text = lastName;
        }
    }else{
        self.nameTF.text = firstName;
    }
    //获取电话
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
     NSString *value = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phone, 0));
    self.phoneTF.text = value;
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"selectedDesireHouseSegue"]) {
        WSSelectHouseTypeViewController *selectdHouseVC = segue.destinationViewController;
        selectdHouseVC.delegate = self;
    }
}
//选择房源delegat
-(void)didSelectedDesierHouseModel:(chooseHouseModel *)currentModel{
    //self.displayModel = currentModel;
    self.disPlayData = [NSMutableArray array];
    [self.disPlayData addObject:currentModel];
    [self.selectedHouseTabelView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.disPlayData.count;
}
#define imageHeadUrl @"http://120.25.153.217"
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TuiJianXuanZeFangYuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tuiJianXuanZeCell" forIndexPath:indexPath];
    if (self.disPlayData.count>0) {
        chooseHouseModel *model = self.disPlayData[0];
        cell.houseNameLabel.text = model.name;
        //cell.descLabel.text = model.;
        //cell.priceLabel.text = model.;
        cell.areaLabel.text = [NSString stringWithFormat:@"%@ %@",model.city,model.area];
        NSString *imageUrl;
        if (model.imgUrl != nil) {
        imageUrl = [imageHeadUrl stringByAppendingString:model.imgUrl];
        }
        //NSString *imageUrl = [imageHeadUrl stringByAppendingString:model.imgUrl];
        imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //NSLog(@"%@",imageUrl);
        if (model.money.length>1) {
        NSString *moneyStr = [NSString stringWithFormat:@"%@ 起",model.money];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:moneyStr];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(str.length-1,1)];
        cell.descLabel.attributedText = str;//[NSString stringWithFormat:@"%@",model.money];
        }
        cell.priceLabel.text = [NSString stringWithFormat:@"%@/㎡",model.price];
        [cell.tuiJianHouseImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"LOGO"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
- (IBAction)submitRecomend:(id)sender {
    chooseHouseModel *model = self.disPlayData[0];
    //NSLog(@"name=%@ phone=%@ houseID=%@",self.nameTF.text,self.phoneTF.text,model.houseID);
    if ((self.nameTF.text.length>0
         )&&(self.phoneTF.text.length>0)&&(model.houseID!= nil)) {
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSString *phoneString = [self.phoneTF.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //NSLog(@"token=%@ name=%@ phone=%@ houseId=%@",userLoginToken,self.nameTF.text,phoneString,model.houseID);
    NSDictionary *para = @{@"tokenId":userLoginToken,@"name":self.nameTF.text,@"phoneNum":phoneString,@"houseId":model.houseID};
    NSString *ipString = submitRecomHouse;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        //NSLog(@"推荐msg%@",statusDict[@"msg"]);
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"msg%@",statusDict[@"msg"]);
            //弹框
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"您已提交成功！您可以在我的－我的客户中查看客户状态信息" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"我的客户", nil];
            [alert show];
        }else{
            //[MBProgressHUD showError:@"该客户已推荐过，请"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:statusDict[@"msg"] delegate:nil
        cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提醒" message:@"推荐信息不完善，请确认后再尝试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        WSmyCustomerViewController *myCusVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myCustomersVC"];
        [self.navigationController showViewController:myCusVC sender:nil];
    }
}
- (IBAction)inPutFinished:(id)sender {
    //[self.view endEditing:YES];
    [self.phoneTF resignFirstResponder];
}

- (IBAction)willInPutPhone:(id)sender {
    [self.phoneTF becomeFirstResponder];
}

- (IBAction)completeInput:(id)sender {
    [UIView animateWithDuration:0.1 animations:^{
        self.submitButton.frame = CGRectMake(0, 342, self.submitButton.bounds.size.width, self.submitButton.bounds.size.height);
    } completion:nil];
    [self.phoneTF resignFirstResponder];
}
@end
