//
//  WLBNumbersDetailViewController.h
//  Wellbeing App
//
//  Created by Xilin Liu on 9/16/14.
//  Copyright (c) 2014 Student Association. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLBNumbersDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *organization;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (strong, nonatomic) NSArray *numberDetail;
@end
