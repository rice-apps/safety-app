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
    var descriptions = [String]()
    lazy var _jsonData = NSDictionary()
    var selectedTitle: String!
    
    // Generic View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        makeRequest()
        self.tableView.rowHeight = 75.0
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
                print(loadedNumbers)
                for entry in loadedNumbers{
                    self.numbers.append(entry["number"] as! String)
                    self.organizations.append(entry["name"] as! String)
                    self.descriptions.append(entry["description"] as! String)
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
        return self.organizations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.numberCellID, forIndexPath: indexPath) as! NumbersTableViewCell
        
        cell.titleLabel.text = self.organizations[indexPath.row]
        cell.detailLabel.text = self.numbers[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! NumbersTableViewCell
        self.selectedTitle = cell.detailLabel.text!
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let segueIdentifier = "segueNumbersDetail"
        
        if segue.identifier == segueIdentifier {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            if let destination = segue.destinationViewController as? NumbersDetailViewController {
                let tableIndex = tableView.indexPathForSelectedRow!.row
                destination.titleValue = self.organizations[tableIndex]
                destination.descriptionValue = self.descriptions[tableIndex]
                destination.numberValue = self.numbers[tableIndex]
                print(self.organizations[tableIndex])
            }
        }
    }

    

}

