//
//  PhotoTweaksViewController.m
//  PhotoTweaks
//
//  Created by Tu You on 14/12/5.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "PhotoTweaksViewController.h"
#import "PhotoTweakView.h"
#import "UIColor+Tweak.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoTweaksViewController ()

@property (strong, nonatomic) PhotoTweakView *photoView;

@end

@implementation PhotoTweaksViewController

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        _image = image;
        _autoSaveToLibray = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor photoTweakCanvasBackgroundColor];
    
    [self setupSubviews];
}

- (void)setupSubviews
{
    self.photoView = [[PhotoTweakView alloc] initWithFrame:self.view.bounds image:self.image];
    self.photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.photoView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(8, CGRectGetHeight(self.view.frame) - 40, 60, 40);
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor cancelButtonColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor cancelButtonHighlightedColor] forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn addTarget:self action:@selector(cancelBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *cropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cropBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    cropBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 60, CGRectGetHeight(self.view.frame) - 40, 60, 40);
    [cropBtn setTitle:@"选择" forState:UIControlStateNormal];
    [cropBtn setTitleColor:[UIColor saveButtonColor] forState:UIControlStateNormal];
    [cropBtn setTitleColor:[UIColor saveButtonHighlightedColor] forState:UIControlStateHighlighted];
    cropBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cropBtn addTarget:self action:@selector(saveBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cropBtn];
}

- (void)cancelBtnTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBtnTapped
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // translate
    CGPoint translation = [self.photoView photoTranslation];
    transform = CGAffineTransformTranslate(transform, translation.x, translation.y);

    // rotate
    transform = CGAffineTransformRotate(transform, self.photoView.angle);
    
    // scale
    CGAffineTransform t = self.photoView.photoContentView.transform;
    CGFloat xScale =  sqrt(t.a * t.a + t.c * t.c);
    CGFloat yScale = sqrt(t.b * t.b + t.d * t.d);
    transform = CGAffineTransformScale(transform, xScale, yScale);
    
    CGImageRef imageRef = [self newTransformedImage:transform
                                        sourceImage:self.image.CGImage
                                         sourceSize:self.image.size
                                  sourceOrientation:self.image.imageOrientation
                                        outputWidth:self.image.size.width
                                           cropSize:self.photoView.cropView.frame.size
                                      imageViewSize:self.photoView.photoContentView.bounds.size];
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    if ([self.delegate respondsToSelector:@selector(finishWithCroppedImage:)]) {
        [self.delegate finishWithCroppedImage:image];
    }
    
    if (self.autoSaveToLibray) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:imageRef metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            if (!error) {
            }
        }];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGImageRef)newScaledImage:(CGImageRef)source withOrientation:(UIImageOrientation)orientation toSize:(CGSize)size withQuality:(CGInterpolationQuality)quality
{
    CGSize srcSize = size;
    CGFloat rotation = 0.0;
    
    switch(orientation)
    {
        case UIImageOrientationUp: {
            rotation = 0;
        } break;
        case UIImageOrientationDown: {
            rotation = M_PI;
        } break;
        case UIImageOrientationLeft:{
            rotation = M_PI_2;
            srcSize = CGSizeMake(size.height, size.width);
        } break;
        case UIImageOrientationRight: {
            rotation = -M_PI_2;
            srcSize = CGSizeMake(size.height, size.width);
        } break;
        default:
            break;
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 size.width,
                                                 size.height,
                                                 8,  //CGImageGetBitsPerComponent(source),
                                                 0,
                                                 CGImageGetColorSpace(source),
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst  //CGImageGetBitmapInfo(source)
                                                 );
    
    CGContextSetInterpolationQuality(context, quality);
    CGContextTranslateCTM(context,  size.width/2,  size.height/2);
    CGContextRotateCTM(context,rotation);
    
    CGContextDrawImage(context, CGRectMake(-srcSize.width/2 ,
                                           -srcSize.height/2,
                                           srcSize.width,
                                           srcSize.height),
                       source);
    
    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    return resultRef;
}

- (CGImageRef)newTransformedImage:(CGAffineTransform)transform
                      sourceImage:(CGImageRef)sourceImage
                       sourceSize:(CGSize)sourceSize
                sourceOrientation:(UIImageOrientation)sourceOrientation
                      outputWidth:(CGFloat)outputWidth
                         cropSize:(CGSize)cropSize
                    imageViewSize:(CGSize)imageViewSize
{
    CGImageRef source = [self newScaledImage:sourceImage
                             withOrientation:sourceOrientation
                                      toSize:sourceSize
                                 withQuality:kCGInterpolationNone];
    
    CGFloat aspect = cropSize.height/cropSize.width;
    CGSize outputSize = CGSizeMake(outputWidth, outputWidth*aspect);
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 outputSize.width,
                                                 outputSize.height,
                                                 CGImageGetBitsPerComponent(source),
                                                 0,
                                                 CGImageGetColorSpace(source),
                                                 CGImageGetBitmapInfo(source));
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, outputSize.width, outputSize.height));
    
    CGAffineTransform uiCoords = CGAffineTransformMakeScale(outputSize.width / cropSize.width,
                                                            outputSize.height / cropSize.height);
    uiCoords = CGAffineTransformTranslate(uiCoords, cropSize.width/2.0, cropSize.height / 2.0);
    uiCoords = CGAffineTransformScale(uiCoords, 1.0, -1.0);
    CGContextConcatCTM(context, uiCoords);
    
    CGContextConcatCTM(context, transform);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(-imageViewSize.width/2.0,
                                           -imageViewSize.height/2.0,
                                           imageViewSize.width,
                                           imageViewSize.height)
                       , source);
    
    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGImageRelease(source);
    return resultRef;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
