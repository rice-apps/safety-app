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
    
    
    let PATH = "http://0.0.0.0:5000/api/blue_button_location"
    var allowActions = false
    
    let locationService = LocationService.sharedInstance
    let backendHandler = BackendHandler.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        let status = locationService.startUpdatingLocation(_emergency: true)
        
        var alert: UIAlertController
        
        if status == -2 {
            alert = UIAlertController(title: "Error posting location", message: "You are not close enough to Rice Campus for RUPD response.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let openAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(openAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        if status == -1 {
            alert = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to notify RUPD of your location in emergencies, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }
            alert.addAction(cancelAction)
            alert.addAction(openAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        // Call RUPD
        let url: URL = URL(string: "telprompt:" + "7133486000")!
        UIApplication.shared.openURL(url)
        print("Calling RUPD")
    }
    
    @IBAction func cancelEmergency(_ sender: AnyObject) {
        print("data serve halted")
        locationService.stopUpdatingLocation()
    }
    
}
    
