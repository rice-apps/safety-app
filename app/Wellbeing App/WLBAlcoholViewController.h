//
//  WLBAlcoholViewController.h
//  Wellbeing App
//
//  Created by Leo Du on 10/27/14.
//  Copyright (c) 2014 Student Association. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLBAlcoholViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *age;

@property (weak, nonatomic) IBOutlet UITextField *weight;

@property (weak, nonatomic) IBOutlet UITextField *drinksAlreadyHad;

@property (weak, nonatomic) IBOutlet UILabel *drinksCanStillHave;

@property (weak, nonatomic) IBOutlet UIPickerView *GenderPicker;

- (IBAction)buttonPressed:(id)sender;

@end
