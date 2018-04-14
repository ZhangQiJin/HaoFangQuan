//
//  WSNewsDetailViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSNewsDetailViewController.h"

@interface WSNewsDetailViewController ()
{
    NSUInteger _collectionState;
}
@end

#define UnCollection 0
#define didCollection 1
@implementation WSNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:self.passedDetailURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.detailWebView loadRequest:request];
    //self.detailWebView.scalesPageToFit = YES;
    _collectionState  = UnCollection;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.subJectLabel.text = self.passedTitle;
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
- (IBAction)delOrAddCollection:(id)sender {
    if (_collectionState == UnCollection) {
        //未收藏
        self.collectionButton.selected = YES;
        _collectionState = didCollection;
    }else{
        //已收藏
        self.collectionButton.selected = NO;
        _collectionState = UnCollection;
    }
}
@end
