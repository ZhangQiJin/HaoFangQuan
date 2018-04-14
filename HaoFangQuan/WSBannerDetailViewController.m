//
//  WSBannerDetailViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/6/23.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSBannerDetailViewController.h"
#import "VIPhotoView.h"
//#import "UIImageView+WebCache.h"
#import "detailImageModel.h"
@interface WSBannerDetailViewController ()<UIScrollViewDelegate>
@property(assign,nonatomic)int huXingCount;
@end

@implementation WSBannerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self seperateBanner];
    [self setUpAppearance];
}
-(void)seperateBanner{
    self.huXingCount = 0;
    for (detailImageModel *model in self.passedBannerArray) {
        if ([model.type isEqualToString:@"0"]) {
            self.huXingCount ++;
        }
    }

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self setUpAppearance];
}
#define imageHeadUrl @"http://120.25.153.217"
-(void)setUpAppearance{
    self.houseImageScrollView.contentSize = CGSizeMake(self.passedBannerArray.count*self.houseImageScrollView.bounds.size.width, self.houseImageScrollView.bounds.size.height);
    for (int i = 0; i<self.passedBannerArray.count; i++) {
        detailImageModel *model = self.passedBannerArray[i];
        NSString *urlStr = [imageHeadUrl stringByAppendingString:model.imgUrl];
        NSURL *url = [NSURL URLWithString:urlStr];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:imageData];
            VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:CGRectMake(i*self.houseImageScrollView.bounds.size.width, 0, self.houseImageScrollView.bounds.size.width, self.houseImageScrollView.bounds.size.height) andImage:image];
            photoView.autoresizingMask = (1 << 6) -1;
            [self.houseImageScrollView addSubview:photoView];
        });
//        NSData *imageData = [NSData dataWithContentsOfURL:url];
//        UIImage *image = [UIImage imageWithData:imageData];
//        VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:CGRectMake(i*self.houseImageScrollView.bounds.size.width, 0, self.houseImageScrollView.bounds.size.width, self.houseImageScrollView.bounds.size.height) andImage:image];
//        photoView.autoresizingMask = (1 << 6) -1;
//        [self.houseImageScrollView addSubview:photoView];
    }
    self.imageCountDisplayLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)self.passedBannerArray.count];
//    for (int i = 0; i<3; i++) {
//        UIImage *image = [UIImage imageNamed:@"teHuiDemo.png"];
//        VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:CGRectMake(i*self.houseImageScrollView.bounds.size.width, 0, self.houseImageScrollView.bounds.size.width, self.houseImageScrollView.bounds.size.height) andImage:image];
//        photoView.autoresizingMask = (1 << 6) -1;
//        [self.houseImageScrollView addSubview:photoView];
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.houseNameLabel.text = self.passedName;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float currentX = scrollView.contentOffset.x;
    int currentPage =(int) currentX/self.houseImageScrollView.bounds.size.width;
    self.imageCountDisplayLabel.text = [NSString stringWithFormat:@"%d/%lu",currentPage+1,(unsigned long)self.passedBannerArray.count];
    if ((currentX>=self.huXingCount*self.houseImageScrollView.bounds.size.width)) {
        self.selectIndexLabel.hidden = YES;
        self.rightSelctedIndexLabel.hidden = NO;
    }else{
        self.selectIndexLabel.hidden = NO;
        self.rightSelctedIndexLabel.hidden = YES;
    }
}
- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)checkHuXing:(id)sender {
    self.selectIndexLabel.hidden = NO;
    self.rightSelctedIndexLabel.hidden = YES;
//    UIButton *currentButton = sender;
//    CGPoint origin = currentButton.center;
//    origin.y = self.selectIndexLabel.center.y;
    //self.selectIndexLabel.center = self.selectIndexLabel.center = CGPointMake(60.0, 521.0);
    //self.selectIndexLabel.frame = CGRectMake(200, self.selectIndexLabel.frame.origin.y, self.selectIndexLabel.frame.size.width, self.selectIndexLabel.frame.size.height);
    //NSLog(@"leftX=%.2lf leftY=%.2lf",self.selectIndexLabel.center.x,self.selectIndexLabel.center.y);
    
    self.houseImageScrollView.contentOffset = CGPointMake(0, self.houseImageScrollView.bounds.origin.y);
    self.imageCountDisplayLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)self.passedBannerArray.count];
}

- (IBAction)checkZhouBian:(id)sender {
    self.selectIndexLabel.hidden = YES;
    self.rightSelctedIndexLabel.hidden = NO;
//    UIButton *currentButton = sender;
//    CGPoint origin = currentButton.center;
//    origin.y = self.selectIndexLabel.center.y;
    //self.selectIndexLabel.center = CGPointMake(260.0, 521.0);
    //self.selectIndexLabel.frame = CGRectMake(200, self.selectIndexLabel.frame.origin.y, self.selectIndexLabel.frame.size.width, self.selectIndexLabel.frame.size.height);
    //NSLog(@"rightX=%.2lf rightY=%.2lf",self.selectIndexLabel.center.x,self.selectIndexLabel.center.y);
//    int huXingCount = 0;
//    for (detailImageModel *model in self.passedBannerArray) {
//        if ([model.type isEqualToString:@"0"]) {
//            huXingCount ++;
//        }
//    }
    self.houseImageScrollView.contentOffset = CGPointMake((self.huXingCount)*self.houseImageScrollView.bounds.size.width, self.houseImageScrollView.bounds.origin.y);
    self.imageCountDisplayLabel.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)self.huXingCount+1,(unsigned long)self.passedBannerArray.count];
}

- (IBAction)checkXiaoGuo:(id)sender {
    UIButton *currentButton = sender;
    CGPoint origin = currentButton.center;
    origin.y = self.selectIndexLabel.center.y;
    self.selectIndexLabel.center = origin;
}
@end
