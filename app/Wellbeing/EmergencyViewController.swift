//
//  EmergencyViewController.swift
//  Wellbeing
//
//  Created by Jeffrey Xiong on 10/18/15.
//  Copyright © 2015 Rice Apps. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class EmergencyViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let RICE_X = 29.719565
    let RICE_Y = -95.402233
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
        
        // API CALL
        /*
        
        POST: 
        riceapps.org/api/blue_button_location
            - send caseID
            - UUID text
            - longitude real
            - latitude real
            - date text
            - resolved default 0
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        
    }
}
    