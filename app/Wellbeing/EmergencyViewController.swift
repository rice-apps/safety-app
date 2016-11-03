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


class EmergencyViewController: UIViewController {
    
    @IBOutlet weak var emergency: UIButton!
    @IBOutlet weak var cancel: UIButton!
    
    let RICE_X = 29.719565
    let RICE_Y = -95.402233
    let RICE_RADIUS = 1000
    let PATH = "http://0.0.0.0:5000/api/blue_button_location"
    var allowActions = false
    
    let locationService = LocationService.sharedInstance
    let backendHandler = BackendHandler.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationService.startUpdatingLocation()
        
        if checkRiceRadius((locationService.currentLocation?.coordinate)!) {
            allowActions = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UI FUNCTIONS
    
    /* 
        Activates location on
    
    */
    @IBAction func activateEmergency(_ sender: AnyObject) {
        if allowActions {
            backendHandler.postLocationToServer(locationService.currentLocation!, path: PATH)
        } else {
            print("wrong place bud")
        }
        
        // Call RUPD
        let url : URL = URL(string: "telprompt:" + "7133486000")!
        UIApplication.shared.openURL(url)
        print("Calling RUPD")
    }
    
    @IBAction func cancelEmergency(_ sender: AnyObject) {
        print("data serve halted")
    }
    
    // HELPER FUNCTIONS
    
    /*
        Checks whether current location is within 1000m of Rice
        Arguments: CLLocationCoordinate2D
        Returns: Bool
    */
    func checkRiceRadius(_ current: CLLocationCoordinate2D) -> Bool {
        let radius = CLLocationDistance.init(RICE_RADIUS)
        let coordinates = CLLocationCoordinate2DMake(RICE_X, RICE_Y)
        let riceRegion = CLCircularRegion(center: coordinates, radius: radius, identifier: "Rice")
        
        if riceRegion.contains(current) {
            return true
        } else {
            return false
        }

    }
}
    
