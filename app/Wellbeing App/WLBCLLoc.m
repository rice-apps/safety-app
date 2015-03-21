//
//  CLLocationManager+WLBCLLoc.m
//  Wellbeing App
//
//  Created by Hailey Elaine Haut on 21/03/2015.
//  Copyright (c) 2015 Student Association. All rights reserved.
//

#import "WLBCLLoc.h"
#import "CoreLocation/CoreLocation.h"

@implementation CLLocationManager (WLBCLLoc)


- (id)init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return self;
}

@end
