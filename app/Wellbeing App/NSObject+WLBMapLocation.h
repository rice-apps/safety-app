//
//  NSObject+WLBMapLocation.h
//  Wellbeing App
//
//  Created by Hailey Elaine Haut on 21/02/2015.
//  Copyright (c) 2015 Student Association. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WLBMapLocation)

@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSString *photoFileName;

@property (nonatomic) float latitude;

@property (nonatomic) float longitude;

@end
