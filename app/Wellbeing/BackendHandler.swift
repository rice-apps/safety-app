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
    
    enum BackendError: Error {
        case serverError
    }
    
    lazy var _jsonData = NSDictionary()
    
    
//    func getLocationsFromServer(_ path: String) {
//        // Gets
//        let url: URL = URL(string: path)!
//        
//        let task = URLSession.shared.dataTask(with: url, completionHandler: {
//            (data, response, error) -> Void in
//            do {
//                
//                if (data == nil) {
//                    throw BackendError.serverError
//                }
//                
//                // Load JSON Object
//                self._jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                
//                // Store relevant entries
//                let loadedNumbers = self._jsonData["result"] as! NSArray
//                print(loadedNumbers)
//                for entry in loadedNumbers{
//                    self.numbers.append(entry["number"] as! String)
//                    self.organizations.append(entry["name"] as! String)
//                    self.descriptions.append(entry["description"] as! String)
//                }
//                self.tableView.reloadData()
//
//            } catch _ {
//                // Error
//            }
//            
//        })
//        task.resume()
//    }
    
    func postRequest(_ postString: String, path: String, background: Bool) {
        
        // format and create request
        let url: URL = URL(string: path)!
        let cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 30.0)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        var session = URLSession.shared
        
        if background {
            let backgroundConfig = URLSessionConfiguration.background(withIdentifier: "x")
            session = URLSession(configuration: backgroundConfig)
        }
        
        // define task
        let task = session.dataTask(with: request, completionHandler: {
            data, response, error in
            
            // error check
            guard error == nil else {
                print("BackendHandler: error with POST request")
                print(error as Any)
                return
            }

            // fetch data
            guard let responseData = data else {
                print("BackendHandler: did not receive data")
                return
            }

            do {
                // get json from data
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: [.mutableContainers, .allowFragments]) as? [String: AnyObject] else {
                    print("BackendHandler: error converting data to JSON")
                    return
                }

                guard let result = json["status"] as? Int else {
                    print("BackendHandler: error fetching status")
                    return
                }
                
                print("status = \(result)")
                
            } catch {
                print("BackendHandler: error converting data to JSON")
            }
            
        })
        
        task.resume()
    }
    
    
    func postLocationToServer(_ location: CLLocation, path: String) {
        
        // Sends POST request to specified server url with unique identifiers and location data.
        // Used for Night Escort + Emergency.
        
        print("serving data")
        
        // get data to pass to server
        let caseID = UUID().uuidString
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        let latitude = "\(location.coordinate.latitude)"
        let longitude = "\(location.coordinate.longitude)"
        
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm:ss"
        let timestamp = dateFormatter.string(from: location.timestamp)
        
        // generate post string
        let postString = "caseID=" + validateURLString(caseID) + "&deviceID=" + validateURLString(deviceID) + "&longitude=" + validateURLString(longitude) + "&latitude=" + validateURLString(latitude) + "&date=" + validateURLString(timestamp) + "&resolved=false"
        
        // format request
        let url: URL = URL(string: path)!
        let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let request = NSMutableURLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        // launch request
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            // error handling
            guard let data = data, let _ = response, error != nil else {
                print("error: \(error)")
                return
            }
            
            // get response
            let responseString = NSString(data: data, encoding:String.Encoding.utf8.rawValue)
            print("response =\(responseString!)")
            
            do {
                // convert to json
                let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .allowFragments]) as? NSDictionary
                if let parseJSON = json {
                    let result = parseJSON["status"] as? String
                    print("status =\(result)")
                }
                
            } catch {
                print("json error: \(error)")
            }
        }) 
        
        task.resume()
        
    }
    
    func validateURLString(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
