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
