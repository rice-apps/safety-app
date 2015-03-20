//
//  MapViewController.h
//  Wellbeing App
//
//  Created by Hailey Elaine Haut on 20/03/2015.
//  Copyright (c) 2015 Student Association. All rights reserved.
//

#ifndef Wellbeing_App_MapViewController_h
#define Wellbeing_App_MapViewController_h

@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
- (IBAction)getCurrentLocation:(id)sender;



#endif
