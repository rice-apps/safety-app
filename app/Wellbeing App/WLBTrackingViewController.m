//
//  WLBTrackingViewController.m
//  Wellbeing App
//
//  Created by Xilin Liu on 9/12/14.
//  Copyright (c) 2014 Student Association. All rights reserved.
//

#import "WLBTrackingViewController.h"

@interface WLBTrackingViewController ()

@end

@implementation WLBTrackingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CLLocationCoordinate2D riceLocation = CLLocationCoordinate2DMake(29.7169, -95.4028);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(riceLocation, 2000, 2000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    self.mapView.showsUserLocation = YES;
    
    self.locationController = [[WLBCoreLocationController alloc] init];
    self.locationController.delegate = self;
    [self.locationController.locationManager startUpdatingLocation];
}

- (void)update:(CLLocation *)location {
    // send [location coordinate].latitude/longitude to backend
}

- (void)locationError:(NSError *)error {
    // print out popup with error
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
