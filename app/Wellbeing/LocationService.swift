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
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    override private init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.distanceFilter = 200
        self.locationManager?.delegate = self
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()

    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        self.currentLocation = location
        
        print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Update Location Error : \(error.description)")
    }
    

}