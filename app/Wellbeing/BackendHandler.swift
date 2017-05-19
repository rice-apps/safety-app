//
//  BackendHandler.swift
//  Wellbeing
//
//  Copyright © 2017 Rice Apps. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class BackendHandler: NSObject {
    
    static let sharedInstance = BackendHandler()
    
    enum BackendError: Error {
        case serverError
    }
    
    func getRequest(_ path: String, completion: @escaping (Dictionary<String, Any>) -> ()) {
        // format and create request
        let url: URL = URL(string: path)!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) -> Void in
            
            // error check
            guard error == nil else {
                print("BackendHandler: error with GET request to url \(path)")
                print(error as Any)
                return
            }
            
            // fetch data
            guard let responseData = data else {
                print("BackendHandler: did not receive data from url \(path)")
                return
            }
            
            do {
                
                // get json from data
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: [.mutableContainers, .allowFragments]) as? [String: AnyObject] else {
                    print("BackendHandler: error converting data from url \(path) to JSON")
                    return
                }
                
                // expose json as dictionary to completion handler
                let jsonData = json as Dictionary <String, Any>
                completion(jsonData)
                
                
            } catch {
                print("BackendHandler: error converting data from url \(path) to JSON")
            }
        })
        
        task.resume()
    }
    
    
    func postRequest(_ postString: String, _ path: String) {
        
        // format and create request
        let url: URL = URL(string: path)!
        let cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 30.0)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        // define task
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            // error check
            guard error == nil else {
                print("BackendHandler: error with POST request \(postString) to url \(path)")
                print(error as Any)
                return
            }

            // fetch data
            guard let responseData = data else {
                print("BackendHandler: did not receive data from url \(path)")
                return
            }

            do {
                // get json from data
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: [.mutableContainers, .allowFragments]) as? [String: AnyObject] else {
                    print("BackendHandler: error converting data from url \(path) to JSON")
                    return
                }

                guard let result = json["status"] as? Int else {
                    print("BackendHandler: error fetching status from url \(path)")
                    return
                }
                
                print("status = \(result)")
                
            } catch {
                print("BackendHandler: error converting data from url \(path) to JSON")
            }
        })
        
        task.resume()
    }
 
    func validateURLString(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
