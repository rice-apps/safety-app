//
//  WLBCoreLocationController.m
//  Wellbeing App
//
//  Created by Xilin Liu on 9/12/14.
//  Copyright (c) 2014 Student Association. All rights reserved.
//

#import "WLBCoreLocationController.h"
#import "CoreLocation/CoreLocation.h"

@implementation WLBCoreLocationController

- (id)init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.delegate update:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.delegate locationError:error];
}

@end
