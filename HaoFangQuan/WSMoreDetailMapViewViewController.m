//
//  WSMoreDetailMapViewViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/6/18.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSMoreDetailMapViewViewController.h"
#import "HMAnnotation.h"
@interface WSMoreDetailMapViewViewController ()<MKMapViewDelegate>
@property (nonatomic, strong) MKPlacemark *sourceMKPm;
@property (nonatomic, strong) MKPlacemark *destinationMKPm;
@end

@implementation WSMoreDetailMapViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpAppearance];
    
//    HMAnnotation *gzAnno = [[HMAnnotation alloc] init];
//    CLLocationCoordinate2D sourceCodinate = CLLocationCoordinate2DMake(self.houseLantitude, self.houseLontitude);
//    gzAnno.coordinate = sourceCodinate;
//    gzAnno.title = @"开始位置";
//    //gzAnno.subtitle = gzPm.name;
//    [self.detailMapView addAnnotation:gzAnno];
    
    HMAnnotation *bjAnno = [[HMAnnotation alloc] init];
    CLLocationCoordinate2D destinationCodinate = CLLocationCoordinate2DMake(self.houseLantitude, self.houseLontitude);
    bjAnno.coordinate = destinationCodinate;
    bjAnno.title = @"楼盘位置";
    //gzAnno.subtitle = gzPm.name;
    [self.detailMapView addAnnotation:bjAnno];
    CLLocationCoordinate2D center = destinationCodinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.detailMapView setRegion:region animated:YES];
    self.detailMapView.mapType = MKMapTypeStandard;
    //self.detailMapView.userTrackingMode = MKUserTrackingModeFollow;
    self.detailMapView.delegate = self;
    //[self drawLineWithSourceCLPm:gzPm destinationCLPm:bjPm];
}

- (void)drawLineWithSourceCLPm:(CLPlacemark *)sourceCLPm destinationCLPm:(CLPlacemark *)destinationCLPm
{
    if (sourceCLPm == nil || destinationCLPm == nil) return;
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    //
    MKPlacemark *sourceMKPm = [[MKPlacemark alloc] initWithPlacemark:sourceCLPm];
    request.source = [[MKMapItem alloc] initWithPlacemark:sourceMKPm];
    self.sourceMKPm = sourceMKPm;
    
    MKPlacemark *destinationMKPm = [[MKPlacemark alloc] initWithPlacemark:destinationCLPm];
    request.destination = [[MKMapItem alloc] initWithPlacemark:destinationMKPm];
    self.destinationMKPm = destinationMKPm;
    //
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) return;
        
        for (MKRoute *route in response.routes) {
            [self.detailMapView addOverlay:route.polyline];
        }
    }];
    //
}

-(void)setUpAppearance{
    //self.detailMapView.userTrackingMode = MKUserTrackingModeFollow;
    //self.dizhiLabel.text = self.huoDongDiZhi;
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
    [self.navigationController popViewControllerAnimated:YES];
}
@end
