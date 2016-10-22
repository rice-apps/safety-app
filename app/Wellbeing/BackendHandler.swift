//
//  ServerController.swift
//  Wellbeing
//
//  Created by Jeffrey Xiong on 4/17/16.
//  Copyright © 2016 Rice Apps. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class BackendHandler: NSObject {
    
    static let sharedInstance = BackendHandler()
    
    
    lazy var _jsonData = NSDictionary()
    
    
    func getLocationsFromServer(path: String) -> [CLLocation] {
        // Gets
        let url: NSURL = NSURL(string: path)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url){
            (data, response, error) -> Void in
            do {
                // Load JSON Object
                self._jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                // Store relevant entries
//                let loadedNumbers = self._jsonData["result"] as! NSArray
//                print(loadedNumbers)
//                for entry in loadedNumbers{
//                    self.numbers.append(entry["number"] as! String)
//                    self.organizations.append(entry["name"] as! String)
//                    self.descriptions.append(entry["description"] as! String)
//                }
//                self.tableView.reloadData()
                
            } catch _ {
                // Error
            }
            
        }
        task.resume()
    }
    
    func postLocationToServer(location: CLLocation, path: String) {
        
        // Sends POST request to specified server url with unique identifiers and location data.
        // Used for Night Escort + Emergency.
        
        print("serving data")
        
        // get data to pass to server
        let caseID = NSUUID().UUIDString
        let deviceID = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let latitude = "\(location.coordinate.latitude)"
        let longitude = "\(location.coordinate.longitude)"
        
        // format date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm:ss"
        let timestamp = dateFormatter.stringFromDate(location.timestamp)
        
        // generate post string
        let postString = "caseID=" + validateURLString(caseID) + "&deviceID=" + validateURLString(deviceID) + "&longitude=" + validateURLString(longitude) + "&latitude=" + validateURLString(latitude) + "&date=" + validateURLString(timestamp) + "&resolved=false"
        
        // format request
        let url: NSURL = NSURL(string: path)!
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        let request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = "POST"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        // launch request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            // handle error
            if error != nil {
                print("error =\(error)")
                return
            }
            
            // get response
            let responseString = NSString(data: data!, encoding:NSUTF8StringEncoding)
            print("response =\(responseString!)")
            
            do {
                // convert to json
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [.MutableContainers, .AllowFragments]) as? NSDictionary
                if let parseJSON = json {
                    let result = parseJSON["status"] as? String
                    print("status =\(result)")
                }
                
            } catch {
                print("json error: \(error)")
            }
        }
        
        task.resume()
        
    }
    
    func validateURLString(string: String) -> String {
        return string.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
    }
}