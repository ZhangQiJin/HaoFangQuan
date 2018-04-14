//
//  WSMoreDetailMapViewViewController.h
//  HaoFangQuan
//
//  Created by Muse on 15/6/18.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface WSMoreDetailMapViewViewController : UIViewController
- (IBAction)turnBack:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *detailMapView;

@property(assign,nonatomic)CGFloat houseLantitude;
@property(assign,nonatomic)CGFloat houseLontitude;
@end
