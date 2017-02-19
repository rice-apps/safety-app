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
    
    let backendHandler = BackendHandler.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Send message to backend
        
    }
    
    
    @IBAction func submitReport(_ sender: AnyObject) {
        // generate post request body string
        let postString = "description=" + backendHandler.validateURLString(reportTextView.text)
        // specify path
        let path: String = "http://0.0.0.0:5000/api/anon_reporting"     // actual path: http://riceapps.org/api/anon_reporting
        // make post request
        backendHandler.postRequest(postString, path: path, background: false)
        
        print("report submitted")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
