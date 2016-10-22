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

class NightEscortViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var trackingMap: MKMapView!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var locateButton: UIButton!
    
    let PATH = "http://localhost:5000/api/escort_location"
    let BUSURL: NSURL = NSURL(string: "http://localhost:5000/api/night_escort")!//http://bus.rice.edu/json/buses.php")
    
    let locationService = LocationService.sharedInstance
    let backendHandler = BackendHandler.sharedInstance

    var loggedIn: Bool {
        get {
            return locateButton.enabled
        } set {
            let loginTitle = newValue ? "Log Out" : "Log In"
            logButton.setTitle(loginTitle, forState: .Normal)
            locateButton.enabled = !newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup
        trackingMap.delegate = self
        trackingMap.hidden = false;
        
        // initiate location services
        locationService.startUpdatingLocation()
        
        if locationService.currentLocation != nil {
            centerMapOnLocation(locationService.currentLocation!)
        }
        
        // get bus location
        loadBusJSON()
        
        if loggedIn {
            // get locations provided
        }
    }
    
    @IBAction func showOrHideLocation(sender: AnyObject) {
        // post user location to server
        backendHandler.postLocationToServer(locationService.currentLocation!, path: PATH)
        // display user on map
    }
    
    
    
    @IBAction func loginOrLogout(sender: AnyObject) {
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
            // Timer for this
            let data = NSData(contentsOfURL: BUSURL)
            print(data)
            let busData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)["d"]
            let escortData: NSDictionary?
            if busData?!.count > 0 && busData?![0]["Name"] as? String == "Night Escort" {
                escortData = busData?![0] as? NSDictionary
                print("Night Escort Latitude: \(escortData!["Latitude"]!)")
                print("Night Escort Longitude: \(escortData!["Longitude"]!)")
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
