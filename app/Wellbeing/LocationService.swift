//
//  LocationService.swift
//  Wellbeing
//
//  Copyright © 2017 Rice Apps. All rights reserved.
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
        if status == CLAuthorizationStatus.authorizedAlways {
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
            
            
            backendHandler.postRequest(postString, path: "http://localhost:5000/api/blue_button_location", background: false)
        }
        
        print("LocationService: Lat \(location.coordinate.latitude), Long \(location.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationService: Update Location Error : \(error.localizedDescription)")
    }
    

    func startSendingLocation() -> Int {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
            
            if checkRiceRadius() {
                print("LocationService: Starting Location Updates")
                self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager?.distanceFilter = 20
                self.postLocation = true
                return 0
            }
            // out of range error
            return -2
        }
        // unauthorized error
        return -1
    }
    

    func stopSendingLocation() {
        print("LocationService: Stop Location Updates")
        self.postLocation = false
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager?.distanceFilter = 200
    }
    

    func checkRiceRadius() -> Bool {
        let radius = CLLocationDistance.init(RICE_RADIUS)
        let coordinates = CLLocationCoordinate2DMake(RICE_X, RICE_Y)
        let riceRegion = CLCircularRegion(center: coordinates, radius: radius, identifier: "Rice")
        
        return riceRegion.contains((self.currentLocation?.coordinate)!)
    }
}
