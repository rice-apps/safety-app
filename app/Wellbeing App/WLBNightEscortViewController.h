//
//  WLBNightEscortViewController.h
//  Wellbeing App
//
//  Created by Xilin Liu on 10/6/14.
//  Copyright (c) 2014 Student Association. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WLBCoreLocationController.h"

@interface WLBNightEscortViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) WLBCoreLocationController *locationController;
@property (nonatomic, retain) MKPointAnnotation *busMarker;


@end
