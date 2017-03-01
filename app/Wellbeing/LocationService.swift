//
//  LocationController.swift
//  Wellbeing
//
//  Created by Jeffrey Xiong on 2/7/16.
//  Copyright © 2016 Rice Apps. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation



class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationService()
    let backendHandler = BackendHandler.sharedInstance
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var postLocation: Bool?
    
    let RICE_X = 29.719565
    let RICE_Y = -95.402233
    let RICE_RADIUS = 1000
    
    override fileprivate init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager?.distanceFilter = 200
        self.locationManager?.delegate = self
        self.postLocation = false
    }
    
    // delegate-defined methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
            self.locationManager?.startUpdatingLocation();
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        self.currentLocation = location
        
        if self.postLocation! {
            // get data to pass to server
            let caseID = backendHandler.validateURLString(UUID().uuidString)
            let deviceID = backendHandler.validateURLString(UIDevice.current.identifierForVendor!.uuidString)
            let latitude = backendHandler.validateURLString("\(location.coordinate.latitude)")
            let longitude = backendHandler.validateURLString("\(location.coordinate.longitude)")
            
            // format date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy hh:mm:ss"
            let timestamp = dateFormatter.string(from: location.timestamp)
            
            // generate post string
            let postString = "caseID=" + caseID + "&deviceID=" + deviceID + "&longitude=" + longitude + "&latitude=" + latitude + "&date=" + timestamp + "&resolved=false"
            
            
            backendHandler.postRequest(postString, path: "http://localhost:5000/api/blue_button_location", background: true)
        }
        
        print("LocationService: Lat \(location.coordinate.latitude), Long \(location.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationService: Update Location Error : \(error.localizedDescription)")
    }
    
    // user-defined methods
    
    func startUpdatingLocation(_emergency: Bool) -> Int {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
            
            if _emergency {
                
                if checkRiceRadius(self.currentLocation!.coordinate) {
                    print("LocationService: Starting Location Updates")
                    self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                    self.locationManager?.distanceFilter = 20
                    self.postLocation = true
                    return 0
                } else {
                    return -2
                }
            } else {
                print("LocationService: Starting Location Updates")
                self.locationManager?.startUpdatingLocation()
                return 0
            }
        }
        
        return -1
    }
    
    func stopUpdatingLocation() {
        print("LocationService: Stop Location Updates")
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager?.distanceFilter = 200
    }
    
    /*
     *  Checks whether current location is within 1000m of Rice
     *  Arguments: CLLocationCoordinate2D
     *  Returns: Bool
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
