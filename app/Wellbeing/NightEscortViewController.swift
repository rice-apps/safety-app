//
//  SecondViewController.swift
//  Wellbeing
//
//  Created by Jeffrey Xiong on 10/18/15.
//  Copyright © 2015 Rice Apps. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class NightEscortViewController: UIViewController {

    @IBOutlet weak var trackingMap: MKMapView!
    @IBOutlet weak var logButton: UIBarButtonItem!
    
    let locationService = LocationService.sharedInstance
    
    var loggedIn: Bool {
        get {
            return !trackingMap.hidden
        }
        set {
            trackingMap.hidden = !newValue
            logButton.title = newValue ? "Log Out" : "Log In"
        }
    }
    let busUrl: NSURL = NSURL(string: "http://localhost:5000")!//http://bus.rice.edu/json/buses.php")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(locationService.currentLocation!)
        loadBusJSON()
    }

    @IBAction func logInOrOut(sender: UIBarButtonItem) {
        if loggedIn {
            loggedIn = false
        } else {
            promptLogin()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        trackingMap.setRegion(coordinateRegion, animated: true)
    }
    
    
    func loadBusJSON() {
        do {
            let data = NSData(contentsOfURL: busUrl)
            let busData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)["d"]
            let escortData: NSDictionary?
            if busData?!.count > 0 && busData?![0]["Name"] as? String == "Night Escort" {
                escortData = busData?![0] as? NSDictionary
                print(escortData!["Latitude"]!)
            }
        } catch {
            print("Could not get NE bus data")
        }
    }
    
    func promptLogin() {
        let alert = UIAlertController(title: "Login", message: "Please login with the provided password", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Login", style: .Default) {
            (action: UIAlertAction) -> Void in
            
            if let tf = alert.textFields?.first {
                if tf.text == "jeffrey" {
                    self.loggedIn = true
                } else {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) {
            (action: UIAlertAction) -> Void in
            // do nothing
            })
        
        alert.addTextFieldWithConfigurationHandler { (textField) in textField.placeholder = "Password" }
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
