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
    
    // Errors
    
    enum NumbersError: Error {
        case serverError
    }
    
    // Generic View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getRequest()
        self.tableView.rowHeight = 75.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // URL Request
    
    func getRequest(){
        let path: String = "http://0.0.0.0:5000/api/numbers"
        let url: URL = URL(string: path)!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) -> Void in
            do {
                // Load JSON Object
                if (data == nil) {
                    throw NumbersError.serverError
                }
                
                let json : Any? = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                if (json == nil) {
                    throw NumbersError.serverError
                }
                
                self._jsonData = json as! NSDictionary
                
                // Store relevant entries
                let loadedNumbers = self._jsonData["result"] as! NSArray
                print(loadedNumbers)
                for entry:AnyObject in loadedNumbers as [AnyObject]{
                    self.numbers.append(entry["number"] as! String)
                    self.organizations.append(entry["name"] as! String)
                    self.descriptions.append(entry["description"] as! String)
                }
                self.tableView.reloadData()
                
            } catch _ {
                
                // Error
            }
            
        })
        task.resume()
        
    }
    
    // Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.organizations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.numberCellID, for: indexPath) as! NumbersTableViewCell
        
        cell.titleLabel.text = self.organizations[(indexPath as NSIndexPath).row]
        cell.detailLabel.text = self.numbers[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.tableView.cellForRow(at: indexPath) as! NumbersTableViewCell
        self.selectedTitle = cell.detailLabel.text!
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let segueIdentifier = "segueNumbersDetail"
        
        if segue.identifier == segueIdentifier {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            if let destination = segue.destination as? NumbersDetailViewController {
                let tableIndex = (tableView.indexPathForSelectedRow! as NSIndexPath).row
                destination.titleValue = self.organizations[tableIndex]
                destination.descriptionValue = self.descriptions[tableIndex]
                destination.numberValue = self.numbers[tableIndex]
                print(self.organizations[tableIndex])
            }
        }
    }

    

}

