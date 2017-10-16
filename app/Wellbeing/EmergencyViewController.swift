//
//  EmergencyViewController.swift
//  Wellbeing
//
//  Copyright © 2017 Rice Apps. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

// TODO:

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
    
    /**
        Selector called when user taps "emergency".
     */
    @IBAction func activateEmergency(_ sender: AnyObject) {
        
        //
        let path: String = "http://0.0.0.0:5000/api/case_id"
        
        backendHandler.getRequest(path) {
            jsonData in
            
            // Get caseID from server
            let caseID = jsonData["result"] as! Int
            self.locationService.setCaseId(caseID)
            
            // Start sending location, based on user
            let status = self.locationService.startSendingLocation()
            
            var alert: UIAlertController
            
            switch status {
            case .OutOfRange:
                alert = UIAlertController(title: "Error Posting Location", message: "You are not close enough to Rice Campus for RUPD response.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            case .NotAuthorized:
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
            case .Authorized:
                break
            }
            
        }
    }
    
    @IBAction func cancelEmergency(_ sender: AnyObject) {
        locationService.stopSendingLocation()
    }
    
}
    
