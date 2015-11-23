//
//  SecondViewController.swift
//  Wellbeing
//
//  Created by Jeffrey Xiong on 10/18/15.
//  Copyright © 2015 Rice Apps. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class NightEscortViewController: UIViewController {

    @IBOutlet weak var trackingMap: MKMapView!
    @IBOutlet weak var logButton: UIBarButtonItem!
    var loggedIn: Bool {
        get {
            return !trackingMap.hidden
        }
        set {
            trackingMap.hidden = !newValue
            logButton.title = newValue ? "Log Out" : "Log In"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logInOrOut(sender: UIBarButtonItem) {
        if loggedIn {
            loggedIn = false
        } else {
            promptLogin()
        }
    }
    
    func promptLogin() {
        let alert = UIAlertController(title: "Login", message: "Please login with the provided password", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Login", style: .Default) {
            (action: UIAlertAction) -> Void in
            
            if let tf = alert.textFields?.first {
                if tf.text == "jeffrey" {
                    self.loggedIn = true
                } else {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) {
            (action: UIAlertAction) -> Void in
            // do nothing
            })
        
        alert.addTextFieldWithConfigurationHandler { (textField) in textField.placeholder = "Password" }
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
