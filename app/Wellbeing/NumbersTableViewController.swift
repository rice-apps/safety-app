//
//  NumbersTableViewController.swift
//  Wellbeing
//
//  Copyright © 2017 Rice Apps. All rights reserved.
//

import Foundation
import UIKit

class NumbersTableViewController: UITableViewController{
    
    let backendHandler = BackendHandler.sharedInstance
    
    // Class Variables
    
    let numberCellID = "numberCell"
    var numbers = [String]()
    var organizations = [String]()
    var descriptions = [String]()
    var selectedTitle: String!
    
    // Generic View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view setup
        self.tableView.rowHeight = 75.0
        
        // get data
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        
        let path: String = "http://0.0.0.0:5000/api/numbers"
        backendHandler.getRequest(path) {
            jsonData in
            
            let loadedNumbers = jsonData["result"] as! NSArray
            print(loadedNumbers)
            for entry:AnyObject in loadedNumbers as [AnyObject] {
                self.numbers.append(entry["number"] as! String)
                self.organizations.append(entry["name"] as! String)
                self.descriptions.append(entry["description"] as! String)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
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

