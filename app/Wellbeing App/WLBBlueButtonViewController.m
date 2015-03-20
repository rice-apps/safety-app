//
//  WLBBlueButtonViewController.m
//  Wellbeing App
//
//  Created by Hailey Elaine Haut on 21/02/2015.
//  Copyright (c) 2015 Student Association. All rights reserved.
//

#import "WLBBlueButtonViewController.h"

@interface WLBBlueButtonViewController ()

@end

@implementation WLBBlueButtonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
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
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)callButtonPush:(id)sender {
    NSLog(@"RUPD successfully requested.");
    
    
    // I got the alert format from StackOverflow,
    // and I tried to fix it to match our needs more, but I'm not sure where to declare buttonIndex or how to manipulate it in the alert window to correspond to the user's action.
    
    NSURL *url = [NSURL URLWithString:@"telprompt://713-367-7602"];
    [[UIApplication  sharedApplication] openURL:url];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Request sent" message:@"If you did not mean to press the button, you can click cancel. Otherwise, RUPD will be called and they will come to your location to assist you." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//    [alert show];
//}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 0){
//        //Cancel action
//            
//    }
//
//    // Put user's location on the map. The user
//    // should not have access to the map, unless
//    // they are logged in under RUPD's name.
//
}
@end
