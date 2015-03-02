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
    [self updateBAC];
}

- (IBAction)updateSelf:(id)sender {
    // Get inputs
    double weightKg = [self.weight.text intValue] * 0.453592;
    double percentWater = self.sex.selectedSegmentIndex == 0 ? 0.58 : 0.49;
    bodyWater = weightKg * percentWater * 1000;
    
    [self updateBAC];
}

- (IBAction)addShot:(id)sender {
    // Source: http://celtickane.com/projects/blood-alcohol-content-bac-calculator/
    // Open console and type "CalcBAC"
    
    // Update alcohol info
    int alcType = (int)self.alcType.selectedSegmentIndex;
    double alcPercent, alcAmount;
    switch (alcType) {
        case 0: // beer
            alcPercent = 4.5;
            alcAmount = 12;
            break;
        case 1: // wine
            alcPercent = 12.5;
            alcAmount = 5;
            break;
        case 2: // liquor
            alcPercent = 40;
            alcAmount = 1.5;
            break;
        default:
            break;
    }
    totalAlcohol += 0.01 * alcPercent * alcAmount * [self.shotsTaken.text intValue];
    
    [self updateBAC];
}

-(void)updateBAC {
    // Calculate BAC
    double metabolism = 0.017;
    double elapsedTime = [self.time.text doubleValue];
    double bac = totalAlcohol / bodyWater * 23.36 * 0.806 * 100;
    // g/oz EtOH, water in blood
    bac -= metabolism * elapsedTime; // average metabolism
    bac = bac >= 0 || bac < 1 ? bac : 0;
    double hDrive = (bac - 0.08) / metabolism;
    if (hDrive < 0)
        hDrive = 0;
    double hSober = bac / metabolism;
    
    self.bac.text = [NSString stringWithFormat:@"%.3f", bac];
    self.hDrive.text = [NSString stringWithFormat:@"%.1f", hDrive];
    self.hSober.text = [NSString stringWithFormat:@"%.1f", hSober];
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
