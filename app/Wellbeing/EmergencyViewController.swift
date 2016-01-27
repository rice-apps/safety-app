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
    
    @IBOutlet weak var emergency: UIButton!
    @IBOutlet weak var cancel: UIButton!
    let locationManager = CLLocationManager()
    let RICE_X = 29.719565
    let RICE_Y = -95.402233
    let RICE_RADIUS = 1000
    var allowActions = false
    var serveEmergencyData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // request location access
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("location enabled")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // LOCATION MANAGER
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let current = locations.last?.coordinate
        
        if checkRiceRadius(current!) {
            // do things if at Rice.
            allowActions = true
            
        }
        
        if serveEmergencyData {
            var timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "updateLocationToServer:", userInfo: locations.last!, repeats: serveEmergencyData)
//            updateLocationToServer(locations.last!)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print(error)
    }
    
    // UI FUNCTIONS
    
    
    /* 
        Activates location on
    
    */
    @IBAction func activateEmergency(sender: AnyObject) {
        if allowActions {
            serveEmergencyData = true
        } else {
            print("wrong place bud")
        }
    }
    
    @IBAction func cancelEmergency(sender: AnyObject) {
        serveEmergencyData = false
        print("data serve halted")
    }
    
    // HELPER FUNCTIONS
    
    /*
        Updates location to server
    */
    func updateLocationToServer(location: CLLocation) {
        
        print("serving data")
//        
//        let uniqueID = UIDevice.currentDevice().identifierForVendor!.UUIDString
//        let latitude = "\(location.coordinate.latitude)"
//        let longitude = "\(location.coordinate.longitude)"
//        // case ID ??? TODO!
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy - hh:mm:ss"
//        
//        let timestamp = dateFormatter.stringFromDate(location.timestamp)
//        
//        let postString = "id=" + validateURLString(uniqueID) + "&timestamp=" + validateURLString(timestamp) + "&latitude=" + validateURLString(latitude) + "&longitude=" + validateURLString(longitude) + "&resolved=false"
//        
//        let path: String = "http://0.0.0.0:5000/api/blue_button_location"
//        let url: NSURL = NSURL(string: path)!
//        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
//        let request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 2.0)
//        request.HTTPMethod = "POST"
//        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            
//            data, response, error in
//            
//            if error != nil {
//                print("error =\(error)")
//                return
//            }
//            
//            let responseString = NSString(data: data!, encoding:NSUTF8StringEncoding)
//            print("response =\(responseString)")
//            
//            do {
//                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [.MutableContainers, .AllowFragments]) as? NSDictionary
//                if let parseJSON = json {
//                    let result = parseJSON["status"] as? String
//                    print("status =\(result)")
//                }
//                // use anyObj here
//            } catch {
//                print("json error: \(error)")
//            }
//        }
//        
//        task.resume()
        
    }
    
    func validateURLString(string: String) -> String {
        return string.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
    }

    
    /*
        Checks whether current location is within 1000m of Rice
        Arguments: CLLocationCoordinate2D
        Returns: Bool
    */
    func checkRiceRadius(current: CLLocationCoordinate2D) -> Bool {
        let radius = CLLocationDistance.init(RICE_RADIUS)
        let coordinates = CLLocationCoordinate2DMake(RICE_X, RICE_Y)
        let riceRegion = CLCircularRegion(center: coordinates, radius: radius, identifier: "Rice")
        
        if riceRegion.containsCoordinate(current) {
            return true
        } else {
            return false
        }

    }
}
    