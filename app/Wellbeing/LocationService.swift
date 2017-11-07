//
//  LocationService.swift
//  Wellbeing
//
//  Copyright © 2017 Rice Apps. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SocketIO


class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationService()
    let backendHandler = BackendHandler.sharedInstance
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var postLocation: Bool?
    var caseID: Int?
    
    let RICE_X = 29.719565
    let RICE_Y = -95.402233
    let RICE_RADIUS = 1000
    
    enum LocationResponse {
        case Authorized
        case OutOfRange
        case NotAuthorized
    }
    
    override fileprivate init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager?.distanceFilter = 200
        self.locationManager?.allowsBackgroundLocationUpdates = true
        self.locationManager?.delegate = self
        self.postLocation = false
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways {
            self.locationManager?.startUpdatingLocation();
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        self.currentLocation = location
        
        
        if self.postLocation! {
            // format arguments
            let caseID = "case_id=" + backendHandler.validateURLString(String(self.caseID!))
            let deviceID = "&device_id=" + backendHandler.validateURLString(UIDevice.current.identifierForVendor!.uuidString)
            let latitude = "&latitude=" + backendHandler.validateURLString("\(location.coordinate.latitude)")
            let longitude = "&longitude=" + backendHandler.validateURLString("\(location.coordinate.longitude)")
            
            // format date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy hh:mm:ss"
            let timestamp = "&timestamp=" + dateFormatter.string(from: location.timestamp)
            
            // generate post string
            let postString = caseID + deviceID + longitude + latitude + timestamp + "&resolved=false"
            
            print("LocationService: Lat \(location.coordinate.latitude), Long \(location.coordinate.longitude)")
            
            backendHandler.postRequest(postString, .BlueButton)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationService: Update Location Error : \(error.localizedDescription)")
    }
    
    func checkLocation() -> LocationResponse {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
            
            if checkRiceRadius() {
                
                return .Authorized
            }
            
            return .OutOfRange
        }
        
        return .NotAuthorized
    }

    func startSendingLocation() -> LocationResponse {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
            
            if checkRiceRadius() {
                print("LocationService: Starting Location Updates")
                self.locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                self.locationManager?.distanceFilter = 5
                self.postLocation = true
                
                return .Authorized
            }
            
            return .OutOfRange
        }
        
        return .NotAuthorized
    }
    

    func stopSendingLocation() {
        print("LocationService: Stop Location Updates")
        self.postLocation = false
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager?.distanceFilter = 200
    }
    
    
    func setCaseId(_ id: Int) {
        self.caseID = id
    }
    

    func checkRiceRadius() -> Bool {
        let radius = CLLocationDistance.init(RICE_RADIUS)
        let coordinates = CLLocationCoordinate2DMake(RICE_X, RICE_Y)
        let riceRegion = CLCircularRegion(center: coordinates, radius: radius, identifier: "Rice")
        
        return riceRegion.contains((self.currentLocation?.coordinate)!)
    }
}
