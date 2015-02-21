//
//  WLBRupdMap.m
//  Wellbeing App
//
//  Created by Hailey Elaine Haut on 21/02/2015.
//  Copyright (c) 2015 Student Association. All rights reserved.
//

#import "WLBRupdMap.h"

@implementation WLBRupdMap

- (Location*)getPointOfInterest
{
    Location *myLocation = [[Location alloc] init];
    myLocation.address = @"Philz Coffee, 399 Golden Gate Ave, San Francisco, CA 94102";
    myLocation.photoFileName = @"coffeebeans.png";
    myLocation.latitude = 37.781453;
    myLocation.longitude = -122.417158;
    
    return myLocation;
}

@end