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
    @IBAction func activateEmergency(sender: AnyObject) {
        if allowActions {
            backendHandler.postLocationToServer(locationService.currentLocation!, path: PATH)
//            updateLocationToServer(locationService.currentLocation!)
        } else {
            print("wrong place bud")
        }
        
        // Call RUPD
        let url : NSURL = NSURL(string: "telprompt:" + "7133486000")!
        UIApplication.sharedApplication().openURL(url)
        print("Calling RUPD")
    }
    
    @IBAction func cancelEmergency(sender: AnyObject) {
        print("data serve halted")
    }
    
    // HELPER FUNCTIONS
    
    /*
        Updates location to server
    */
//    func updateLocationToServer(location: CLLocation) {
//        
//        print("serving data")
//        
//        let caseID = NSUUID().UUIDString
//        let deviceID = UIDevice.currentDevice().identifierForVendor!.UUIDString
//        let latitude = "\(location.coordinate.latitude)"
//        let longitude = "\(location.coordinate.longitude)"
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy - hh:mm:ss"
//        
//        let timestamp = dateFormatter.stringFromDate(location.timestamp)
//        
//        let postString = "caseID=" + validateURLString(caseID) + "&deviceID=" + validateURLString(deviceID) + "&longitude=" + validateURLString(longitude) + "&latitude=" + validateURLString(latitude) + "&date=" + validateURLString(timestamp) + "&resolved=false"
//        print(postString)
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
//            print("response =\(responseString!)")
//            
//            do {
//                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [.MutableContainers, .AllowFragments]) as? NSDictionary
//                if let parseJSON = json {
//                    let result = parseJSON["status"] as? String
//                    print("status =\(result)")
//                }
//                
//            } catch {
//                print("json error: \(error)")
//            }
//        }
//        
//        task.resume()
//        
//    }
//    
//    func validateURLString(string: String) -> String {
//        return string.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
//    }

    
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
    