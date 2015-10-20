//
//  FirstViewController.swift
//  Wellbeing
//
//  Created by Jeffrey Xiong on 10/18/15.
//  Copyright © 2015 Rice Apps. All rights reserved.
//

import Foundation
import UIKit

class NumbersTableViewController: UITableViewController{
    
    // Class Variables
    
    let numberCellID = "numberCell"
    var numbers = [String]()
    var organizations = [String]()
    lazy var _jsonData = NSDictionary()
    
    // Generic View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        makeRequest()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // URL Request
    
    func makeRequest(){
        let path: String = "http://riceapps.org:19125/api/numbers"
        let url: NSURL = NSURL(string: path)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url){
            (data, response, error) -> Void in
            do {
                // Load JSON Object
                self._jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                // Store relevant entries
                let loadedNumbers = self._jsonData["result"] as! NSArray
                for entry in loadedNumbers{
                    self.numbers.append(entry["number"] as! String)
                    self.organizations.append(entry["name"] as! String)
                }
                self.tableView.reloadData()
                
            } catch _ {
                // Error
            }
            
        }
        task.resume()
        
    }
    
    // Table View
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(String(self.organizations))
        return self.organizations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.numberCellID, forIndexPath: indexPath)
        
        cell.textLabel?.text = self.organizations[indexPath.row]
        cell.detailTextLabel?.text = self.numbers[indexPath.row]
        
        return cell
    }
    
    

}

