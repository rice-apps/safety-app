//
//  WLBNumbersDetailViewController.m
//  Wellbeing App
//
//  Created by Xilin Liu on 9/16/14.
//  Copyright (c) 2014 Student Association. All rights reserved.
//

#import "WLBNumbersDetailViewController.h"

@interface WLBNumbersDetailViewController ()

@end

@implementation WLBNumbersDetailViewController
{
    NSString *numberToCall;
}

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
    numberToCall = _numberDetail[1];
    _organization.text = _numberDetail[0];
    _number.text = _numberDetail[1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callNumber:(id)sender {
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",numberToCall]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        NSLog(@"Call failed");
    }
}
@end
