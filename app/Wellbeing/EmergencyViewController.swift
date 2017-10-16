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
        
        // Check location
        let status = self.locationService.checkLocation()
        var alert: UIAlertController
        
        switch status {
            
        case .OutOfRange:
            // Initialize AlertController
            alert = UIAlertController(title: "Error Posting Location", message: "You are not close enough to Rice Campus for RUPD response.", preferredStyle: .alert)
            // Add actions
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            // Present controller
            self.present(alert, animated: true, completion: nil)
        case .NotAuthorized:
            // Initialize AlertController
            alert = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to notify RUPD of your location in emergencies, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .alert)
            // Add actions
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }
            alert.addAction(cancelAction)
            alert.addAction(openAction)
            // Present controller
            self.present(alert, animated: true, completion: nil)
        case .Authorized:
            self.startEmergencyRequest()
        }
        
        // Call RUPD in either case
        let url: URL = URL(string: "telprompt://" + "6264667618")!
        UIApplication.shared.openURL(url)
        print("Calling RUPD")
    }
    
    func startEmergencyRequest() {
        
        backendHandler.getRequest(.CaseID) {
            jsonData in
            
            // Get caseID from server
            let caseID = jsonData["result"] as! Int
            self.locationService.setCaseId(caseID)
            print("Case ID: \(caseID)")
            
            // Start sending location
            let status = self.locationService.startSendingLocation()
            assert(status == .Authorized)
        }
    }
    
    @IBAction func cancelEmergency(_ sender: AnyObject) {
        locationService.stopSendingLocation()
    }
    
}
    
