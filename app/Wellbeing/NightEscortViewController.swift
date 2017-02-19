////
////  SecondViewController.swift
////  Wellbeing
////
////  Created by Jeffrey Xiong on 10/18/15.
////  Copyright © 2015 Rice Apps. All rights reserved.
////
//
import Foundation
import UIKit
import MapKit
//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}
//
//fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l > r
//  default:
//    return rhs < lhs
//  }
//}
//
//
class NightEscortViewController: UIViewController, MKMapViewDelegate {
//
//    @IBOutlet weak var trackingMap: MKMapView!
//    @IBOutlet weak var logButton: UIButton!
//    @IBOutlet weak var locateButton: UIButton!
//    
//    let PATH = "http://localhost:5000/api/escort_location"
//    let BUSURL: URL = URL(string: "http://localhost:5000/api/night_escort")!//http://bus.rice.edu/json/buses.php")
//    
//    let locationService = LocationService.sharedInstance
//    let backendHandler = BackendHandler.sharedInstance
//
//    var loggedIn: Bool {
//        get {
//            return locateButton.isEnabled
//        } set {
//            let loginTitle = newValue ? "Log Out" : "Log In"
//            logButton.setTitle(loginTitle, for: UIControlState())
//            locateButton.isEnabled = !newValue
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // setup
//        trackingMap.delegate = self
//        trackingMap.isHidden = false;
//        
//        // initiate location services
//        locationService.startUpdatingLocation()
//        
//        if locationService.currentLocation != nil {
//            centerMapOnLocation(locationService.currentLocation!)
//        }
//        
//        // get bus location
//        loadBusJSON()
//        
//        if loggedIn {
//            // get locations provided
//        }
//    }
//    
//    @IBAction func showOrHideLocation(_ sender: AnyObject) {
//        // post user location to server
//        backendHandler.postLocationToServer(locationService.currentLocation!, path: PATH)
//        // display user on map
//    }
//    
//    
//    
//    @IBAction func loginOrLogout(_ sender: AnyObject) {
//        if loggedIn {
//            loggedIn = false
//        } else {
//            promptLogin()
//        }
//    }
//    
//    func centerMapOnLocation(_ location: CLLocation) {
//        let regionRadius: CLLocationDistance = 1000
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
//        trackingMap.setRegion(coordinateRegion, animated: true)
//    }
//    
//    
//    func loadBusJSON() {
//        do {
//            // Timer for this
//            let data = try? Data(contentsOf: BUSURL)
//            print(data)
//            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
//            let busData = json["d"]
//            let escortData: NSDictionary?
//            if busData.count > 0 && busData?![0]["Name"] as? String == "Night Escort" {
//                escortData = busData[0] as? NSDictionary
//                print("Night Escort Latitude: \(escortData!["Latitude"]!)")
//                print("Night Escort Longitude: \(escortData!["Longitude"]!)")
//            }
//        } catch {
//            print("Could not get NE bus data")
//        }
//    }
//    
//    func promptLogin() {
//        let alert = UIAlertController(title: "Login", message: "Please login with the provided password", preferredStyle: UIAlertControllerStyle.alert)
//        
//        alert.addAction(UIAlertAction(title: "Login", style: .default) {
//            (action: UIAlertAction) -> Void in
//            
//            if let tf = alert.textFields?.first {
//                if tf.text == "jeffrey" {
//                    self.loggedIn = true
//                } else {
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//            })
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) {
//            (action: UIAlertAction) -> Void in
//            // do nothing
//            })
//        
//        alert.addTextField { (textField) in textField.placeholder = "Password" }
//        
//        present(alert, animated: true, completion: nil)
//    }
}
