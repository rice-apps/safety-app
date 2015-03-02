//
//  WLBAlcoholViewController.m
//  Wellbeing App
//
//  Created by Leo Du on 10/27/14.
//  Copyright (c) 2014 Student Association. All rights reserved.
//

#import "WLBAlcoholViewController.h"

@interface WLBAlcoholViewController ()

@end

@implementation WLBAlcoholViewController {
    double bodyWater;
    double totalAlcohol;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clear:(id)sender {
    totalAlcohol = 0;
}

- (IBAction)addShot:(id)sender {
    // Source: http://celtickane.com/projects/blood-alcohol-content-bac-calculator/
    // Open console and type "CalcBAC"
    
    // Get inputs
    double weightKg = [self.weight.text intValue] * 0.453592;
    double percentWater = self.sex.selectedSegmentIndex == 0 ? 0.58 : 0.49;
    double elapsedTime = [self.time.text doubleValue];
    bodyWater = weightKg * percentWater * 1000;
    
    // Update alcohol info
    int alcType = (int)self.alcType.selectedSegmentIndex;
    double alcPercent;
    switch (alcType) {
        case 0: // beer
            alcPercent = 4.5;
            break;
        case 1: // wine
            alcPercent = 12.5;
            break;
        case 2: // liquor
            alcPercent = 40;
            break;
        default:
            break;
    }
    totalAlcohol += alcPercent * [self.shotsTaken.text intValue];
    
    // Calculate BAC
    double bac = totalAlcohol / bodyWater * 23.36 * 0.806 * 100;
    // g/oz EtOH, water in blood
    bac -= 0.2 * elapsedTime; // average metabolism
    bac = bac > 0 ? bac : 0;
    
    [self updateInformation:bac];
}

-(void)updateInformation:(double)bac {
    self.shotsLeft.text = [NSString stringWithFormat:@"%01f", bac];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
