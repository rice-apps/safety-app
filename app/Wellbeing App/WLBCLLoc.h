//
//  CLLocationManager+WLBCLLoc.h
//  Wellbeing App
//
//  Created by Hailey Elaine Haut on 21/03/2015.
//  Copyright (c) 2015 Student Association. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
@import CoreLocation;

@interface CLLocationManager (WLBCLLoc)

@property(assign, nonatomic) CLLocationAccuracy desiredAccuracy;

@property(assign, nonatomic) CLLocationDistance distanceFilter;

@end
