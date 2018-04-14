//
//  WSAddCustomerViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/6/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSAddCustomerViewController.h"
#import "PhotoTweaksViewController.h"
#import "WSmyCustomerViewController.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
@interface WSAddCustomerViewController ()<UITextFieldDelegate,UIActionSheetDelegate,PhotoTweaksViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSUInteger _pushIndex;
}
@property(strong,nonatomic)NSArray *chooseTableData;
@property(strong,nonatomic)NSArray *purpuseArray;
@property(strong,nonatomic)NSArray *apartmentArray;
@property(strong,nonatomic)NSArray *priceRangeArray;
@end
#define purpuse 0
#define apartment 1
#define price_range 2
@implementation WSAddCustomerViewController
#define imageHeadUrl @"http://120.25.153.217"
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatTempData];
    [self setUpAppearance];
    [self setUpHeadImage];
}
-(void)setUpHeadImage{
    NSString *headImgUrl = self.passedModel.imgUrl;
    NSString *imageUrl = imageHeadUrl;
    if (headImgUrl != nil) {
        imageUrl = [imageHeadUrl stringByAppendingString:headImgUrl];
    }
    imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"aboutMeHeadDefau"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
}

//临时数据
-(void)creatTempData{
    self.purpuseArray = @[@"婚房",@"学区房",@"老人房",@"改善房",@"投资房"];
    self.apartmentArray = @[@"住宅社区",@"酒店式公寓",@"写字楼",@"别墅",@"商业",@"商铺"];
    self.priceRangeArray = @[@"30万以下",@"30-50万",@"50-70万",@"70-90万",@"100万以上"];
}
-(void)setUpAppearance{
    self.headImageView.layer.cornerRadius = 30.0f;
    self.headImageView.layer.masksToBounds = YES;
    [self.chooseTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"chooseCell"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.showIndex isEqualToString:@"modify"]) {
        self.nameTextField.text = self.passedModel.name;
        self.phoneTextField.text = self.passedModel.phone;
        self.objectLabel.text = @"修改客户资料";
        self.purposeLabel.text = self.passedModel.purpose;
        self.houseTypeLabel.text = self.passedModel.apartMent;
        self.priceRangeLabel.text = self.passedModel.priceRange;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma textField_delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.phoneTextField) {
        if ((!(textField.text.length == 11))||(![self isMobileNumber:textField.text])) {
            self.phoneTextField.text = @"";
//            UIAlertView *alet = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"电话号码格式有误，请确认后重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alet show];
        }
    }else if (textField == self.nameTextField){
        if (textField.text.length<2||textField.text.length>8) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"姓名长度只能为2-8个字符,请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
            self.nameTextField.text = @"";
        }
        if (![self isChinesecharacter:textField.text]) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"姓名只能为汉字,请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
            self.nameTextField.text = @"";
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
    NSString * CT = @"^1((33|53|8[091])[0-9]|349)\\d{7}$";
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
//    if (string.length == 0) {
//        return NO;    }
//    unichar c = [string characterAtIndex:0];
//    if (c >=0x4E00 && c <=0x9FA5){
//        return YES;//汉字
//    }else{
//        return NO;//英文
//    }
    NSString *regex = @"[\u4e00-\u9fa5][\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject: string];
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField == self.phoneTextField) {
//        if (textField.text.length<11) {
//            return YES;
//        }else{
//            return NO;
//        }
//    }else{
//        return YES;
//    }
//}
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

- (IBAction)finishAddCustomer:(id)sender {
    if ((self.phoneTextField.text != nil)&&(self.nameTextField.text != nil)) {
    [MBProgressHUD showMessage:@"正在拼命提交..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken =[[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *json =nil;
    if ([self.showIndex isEqualToString:@"modify"]) {
        json = @{@"tokenId":userLoginToken,@"name":self.nameTextField.text,@"phoneNum":self.phoneTextField.text,@"purpose":self.purposeLabel.text,@"apartment":self.houseTypeLabel.text,@"priceRange":self.priceRangeLabel.text,@"id":self.passedModel.ID};
    }else{
        json = @{@"tokenId":userLoginToken,@"name":self.nameTextField.text,@"phoneNum":self.phoneTextField.text,@"purpose":self.purposeLabel.text,@"apartment":self.houseTypeLabel.text,@"priceRange":self.priceRangeLabel.text};
    }
    NSDictionary *para = [NSDictionary dictionary];
    para = @{@"json" :json};
    NSString *ipString = addCustomers;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (self.headImageView.image != nil) {
            NSLog(@"image%@",self.headImageView.image);
            NSData *data = UIImageJPEGRepresentation(self.headImageView.image , 0.5);
            //拼接文件参数
            [formData appendPartWithFileData:data name:@"file" fileName:@"customerHead.jpg" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict){
        [MBProgressHUD hideHUD];
        NSString *respond = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
//        NSLog(@"respond%@",respond);//responseObject);
        if ([respond isEqualToString:@"0"]) {
            //[MBProgressHUD showSuccess:@"添加成功"];
            for (UIViewController*temp in self.navigationController.viewControllers) {
                if ([temp isMemberOfClass:[WSmyCustomerViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }else{
            [MBProgressHUD showError:statusDict[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"提交失败"];
    }];}else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"客户信息不完善,请补充完整后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)choosePurpose:(id)sender {
    [self.view endEditing:YES];
    _pushIndex = purpuse;
    //self.purpuseChooseButton.enabled = YES;
    self.apartmentChooseButton.enabled = NO;
    self.priceRangeChooseButton.enabled = NO;
    self.chooseBackView.hidden = NO;
    self.chooseTableData = [self.purpuseArray copy];
    [self.chooseTableView reloadData];
}

- (IBAction)chooseHouseType:(id)sender {
    [self.view endEditing:YES];
    _pushIndex = apartment;
    //self.apartmentChooseButton.enabled = YES;
    self.purpuseChooseButton.enabled = NO;
    self.priceRangeChooseButton.enabled = NO;
    self.chooseBackView.hidden = NO;
    self.chooseTableData = [self.apartmentArray copy];
    [self.chooseTableView reloadData];
}

- (IBAction)choosePriceRange:(id)sender {
    [self.view endEditing:YES];
    _pushIndex = price_range;
    //self.priceRangeChooseButton.enabled = YES;
    self.apartmentChooseButton.enabled = NO;
    self.purpuseChooseButton.enabled = NO;
    self.chooseBackView.hidden = NO;
    self.chooseTableData = [self.priceRangeArray copy];
    [self.chooseTableView reloadData];
}
- (IBAction)chooseHeadImage:(id)sender {
    [self.view endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取", nil];
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.navigationBarHidden = YES;
        [self showDetailViewController:picker sender:nil];
    }else if (buttonIndex == 1){
//        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
//        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
//        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
//        ipc.delegate = self;
//        [self presentViewController:ipc animated:YES completion:nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //self.headImageView.image = image;
    PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:image];
    photoTweaksViewController.delegate = self;
    photoTweaksViewController.autoSaveToLibray = YES;
    [picker pushViewController:photoTweaksViewController animated:YES];
}

- (void)finishWithCroppedImage:(UIImage *)croppedImage
{
    self.headImageView.image = croppedImage;
//    NSData *imageData = UIImageJPEGRepresentation(self.headImageView.image, 0.5);
//    NSUserDefaults *defaul = [NSUserDefaults standardUserDefaults];
//    [defaul setObject:imageData forKey:@"userHeadImage"];
//    [defaul synchronize];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"headPicture.png"]];   // 保存文件的名称
//    [UIImagePNGRepresentation(croppedImage)writeToFile: filePath atomically:YES];
    //NSLog(@"before%@",filePath);
//    NSUserDefaults *defall = [NSUserDefaults standardUserDefaults];
//    [defall setObject:filePath forKey:@"headPicturePath"];
//    [defall synchronize];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chooseTableData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseCell" forIndexPath:indexPath];
    NSString *currentString = self.chooseTableData[indexPath.row];
    //NSLog(@"currentString%@",currentString);
    cell.textLabel.text = currentString;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *currentString = self.chooseTableData[indexPath.row];
    if (_pushIndex == purpuse) {
        self.purposeLabel.text =currentString;
        self.chooseBackView.hidden = YES;
    }else if (_pushIndex == apartment){
        self.houseTypeLabel.text = currentString;
        self.chooseBackView.hidden = YES;
    }else{
        self.priceRangeLabel.text = currentString;
        self.chooseBackView.hidden = YES;
    }
    self.purpuseChooseButton.enabled = YES;
    self.apartmentChooseButton.enabled = YES;
    self.priceRangeChooseButton.enabled = YES;
}
- (IBAction)confirmCurrentChoose:(id)sender {
    self.chooseBackView.hidden = YES;
    self.purpuseChooseButton.enabled = YES;
    self.apartmentChooseButton.enabled = YES;
    self.priceRangeChooseButton.enabled = YES;
}

- (IBAction)cancelCurrentChoose:(id)sender {
    self.chooseBackView.hidden = YES;
    self.purpuseChooseButton.enabled = YES;
    self.apartmentChooseButton.enabled = YES;
    self.priceRangeChooseButton.enabled = YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
