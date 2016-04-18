//
//  NumbersDetailViewController.swift
//  Wellbeing
//
//  Created by Jeffrey Xiong on 10/26/15.
//  Copyright © 2015 Rice Apps. All rights reserved.
//

import Foundation
import UIKit

class NumbersDetailViewController: UIViewController {
    
    var titleValue = String()
    var descriptionValue = String()
    var numberValue = String()
    
    
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleValue
        descriptionTextView.text = descriptionValue
        descriptionTextView.scrollEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callBtnPressed(sender: AnyObject) {
        let url : NSURL = NSURL(string: "telprompt:" + numberValue)!
        UIApplication.sharedApplication().openURL(url)
        print("Calling" + numberValue)
    }
}
   