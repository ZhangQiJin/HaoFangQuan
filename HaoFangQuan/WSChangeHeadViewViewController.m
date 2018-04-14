//
//  WSChangeHeadViewViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSChangeHeadViewViewController.h"
#import "PhotoTweaksViewController.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
@interface WSChangeHeadViewViewController ()<UIImagePickerControllerDelegate,PhotoTweaksViewControllerDelegate,UINavigationControllerDelegate>

@end

@implementation WSChangeHeadViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    //向服务器发送头像信息
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken =[[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *json = @{@"tokenId":userLoginToken};
    NSDictionary *para = [NSDictionary dictionary];
    para = @{@"json":json};
    NSString *ipString = changeMyHeadImage;
    //NSLog(@"para%@",para);
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (self.bigHeadImageView.image != nil) {
            //NSLog(@"image%@",self.bigHeadImageView.image);
            NSData *data = UIImageJPEGRepresentation(self.bigHeadImageView.image , 0.5);
            //拼接文件参数
            [formData appendPartWithFileData:data name:@"file" fileName:@"myHead.jpg" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict){
        //NSLog(@"respond%@",respond);
        NSString *myHeadImgUrl = statusDict[@"url"];
        //NSLog(@"changedHeadUrl%@",myHeadImgUrl);
        NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
        [defa setObject:myHeadImgUrl forKey:@"myHeadImageUrl"];
        [defa synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error%@",error);
    }];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseImageFromAlbum:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.navigationBarHidden = YES;
    [self showDetailViewController:picker sender:nil];
}

- (IBAction)takePhoto:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:image];
    photoTweaksViewController.delegate = self;
    photoTweaksViewController.autoSaveToLibray = YES;
    [picker pushViewController:photoTweaksViewController animated:YES];
}

- (void)finishWithCroppedImage:(UIImage *)croppedImage
{
    self.bigHeadImageView.image = croppedImage;
    NSData *imageData = UIImageJPEGRepresentation(self.bigHeadImageView.image, 0.5);
    NSUserDefaults *defaul = [NSUserDefaults standardUserDefaults];
    [defaul setObject:imageData forKey:@"userHeadImage"];
    [defaul synchronize];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"headPicture.png"]];   // 保存文件的名称
//    [UIImagePNGRepresentation(croppedImage)writeToFile: filePath atomically:YES];
    //NSLog(@"before%@",filePath);
//    NSUserDefaults *defall = [NSUserDefaults standardUserDefaults];
//    [defall setObject:filePath forKey:@"headPicturePath"];
//    [defall synchronize];
    
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
//    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
//    NSString *userLoginToken =[[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
//    //NSLog(@"loginToken%@",userLoginToken);
//    NSDictionary *json = @{@"tokenId":userLoginToken};
//    NSDictionary *para = [NSDictionary dictionary];
//    para = @{@"json" :json};
//    NSString *ipString = changeMyHeadImage;
//    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [mgr POST:ipString parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        if (self.bigHeadImageView.image != nil) {
//            NSLog(@"image%@",self.bigHeadImageView.image);
//            NSData *data = UIImageJPEGRepresentation(self.bigHeadImageView.image , 0.5);
//            //拼接文件参数
//            [formData appendPartWithFileData:data name:@"file" fileName:@"myHead.jpg" mimeType:@"image/jpeg"];
//        }
//    } success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict){
//        NSString *respond = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
//        NSLog(@"respond%@",statusDict);
//        NSLog(@"%@",statusDict[@"msg"]);
//        if ([respond isEqualToString:@"0"]) {
//            //[MBProgressHUD showSuccess:@"添加成功"];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error");
//    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userHeadImage"];
    if (data!= nil) {
        UIImage *headimage = [UIImage imageWithData:data];
        //NSLog(@"%@",headimage);
        //[self.loginButton setImage:headimage forState:UIControlStateNormal];
        self.bigHeadImageView.layer.cornerRadius = 49;
        self.bigHeadImageView.layer.masksToBounds = YES;
        self.bigHeadImageView.image = headimage;
    }
    //[self refreshDisPlay];
}

@end
