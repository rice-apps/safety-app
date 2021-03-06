//
//  NumbersDetailViewController.swift
//  Wellbeing
//
//  Copyright © 2017 Rice Apps. All rights reserved.
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
        descriptionTextView.isScrollEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callBtnPressed(_ sender: AnyObject) {
        let url : URL = URL(string: "telprompt:" + numberValue)!
        UIApplication.shared.openURL(url)
        print("Calling" + numberValue)
    }
}
   
