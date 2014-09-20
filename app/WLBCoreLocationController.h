//
//  WLBCoreLocationController.h
//  Wellbeing App
//
//  Created by Xilin Liu on 9/12/14.
//  Copyright (c) 2014 Student Association. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

@protocol CoreLocationControllerDelegate
@required
- (void)update:(CLLocation *) location;
- (void)locationError:(NSError *)error;
@end

@interface WLBCoreLocationController : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) id delegate;

@end
