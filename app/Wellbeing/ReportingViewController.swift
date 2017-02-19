//
//  ReportingViewController.swift
//  Wellbeing
//
//  Created by Jeffrey Xiong on 10/18/15.
//  Copyright © 2015 Rice Apps. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ReportingViewController: UIViewController {
    
    @IBOutlet weak var reportTextView: UITextView!
    @IBOutlet weak var submitReportBtn: UIButton!
    
    let locationService = LocationService.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Send message to backend
        
    }
    
    func postRequest(_ content: String) {
        // create post request
        let postString = "description=" + content.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let path: String = "http://0.0.0.0:5000/api/anon_reporting"     // actual path: http://riceapps.org/api/anon_reporting
        let url: URL = URL(string: path)!
        let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let request = NSMutableURLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        // create url config
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = TimeInterval(15)
        urlconfig.timeoutIntervalForResource = TimeInterval(15)
        
        
        // define session and task
        let session = URLSession(configuration: urlconfig)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            
            // error check
            guard error == nil else {
                print("Anon Reporting: error with POST request")
                print(error as Any)
                return
            }
            
            // fetch data
            guard let responseData = data else {
                print("Anon Reporting: did not receive data")
                return
            }
            
            do {
                // get json from data
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: [.mutableContainers, .allowFragments]) as? [String: AnyObject] else {
                    print("Anon Reporting: error converting data to JSON")
                    return
                }
                
                guard let result = json["status"] as? Int else {
                    print("Anon Reporting: error fetching status")
                    return
                }
                
                print("status = \(result)")
                
            } catch {
                print("Anon Reporting: error converting data to JSON")
            }
            
            
        })
        
        task.resume()
        
//        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
//            
//            data, response, error in
//            
//            if error != nil {
//                print("error =\(error)")
//                return
//            }
//            
//            let responseString = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
//            print("response =\(responseString!)")
//            
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers, .allowFragments]) as? NSDictionary
//                if let parseJSON = json {
//                    let result = parseJSON["status"] as? String
//                    print("status =\(result)")
//                }
//                // use anyObj here
//            } catch {
//                print("json error: \(error)")
//            }
//        }) 
//        
//        task.resume()
        
        
    }
    
    @IBAction func submitReport(_ sender: AnyObject) {
        postRequest(reportTextView.text)
        print("report submitted")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
