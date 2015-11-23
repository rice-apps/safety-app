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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Send message to backend
        
        
        
    }
    
    func postRequest(content: String) {
        let postString = "description=" + content.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        
        let path: String = "http://riceapps.org:19125/api/anon_reporting"
        let url: NSURL = NSURL(string: path)!
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        let request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = "POST"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            
            data, response, error in
            
            if error != nil {
                print("error =\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding:NSUTF8StringEncoding)
            print("response =\(responseString)")
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                if let parseJSON = json {
                    let description = parseJSON["description"] as? String
                    print("description =\(description)")
                }
                // use anyObj here
            } catch {
                print("json error: \(error)")
            }
        }
        
        task.resume()
        
        
    }
    
    @IBAction func submitReport(sender: AnyObject) {
        postRequest(reportTextView.text)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}