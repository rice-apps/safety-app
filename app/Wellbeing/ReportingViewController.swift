//
//  ReportingViewController.swift
//  Wellbeing
//
//  Copyright © 2017 Rice Apps. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class ReportingViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self;
        view = webView;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://rupdadmin.rice.edu/witnessreports/create/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    
    
}
