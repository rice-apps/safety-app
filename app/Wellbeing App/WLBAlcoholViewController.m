//
//  WLBAlcoholViewController.m
//  Wellbeing App
//
//  Created by Leo Du on 10/27/14.
//  Copyright (c) 2014 Student Association. All rights reserved.
//

#import "WLBAlcoholViewController.h"

@interface WLBAlcoholViewController ()

@property (strong,nonatomic) NSArray *genderArray;
@end

@implementation WLBAlcoholViewController {
    NSString *genderSelected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *array = [[NSArray alloc] initWithObjects:@"Male",@"Female",nil];
    self.genderArray = array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    
    NSString *select = [_genderArray objectAtIndex:[_GenderPicker selectedRowInComponent:0]];
    genderSelected = select;
    
    NSInteger weight = [self.weight.text intValue];
    
    NSInteger age = [self.age.text intValue];
    
    NSInteger drinksHad = [self.drinksAlreadyHad.text intValue];

    NSString *textToShow = [NSString stringWithFormat:@"%ld",weight + age + drinksHad];
    
    self.drinksCanStillHave.text = textToShow;

}



- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_genderArray count];
}

#pragma mark picker delegate

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_genderArray objectAtIndex:row];
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
