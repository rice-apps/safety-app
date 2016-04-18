//
//  CalculatorViewController.swift
//  Wellbeing
//
//  Created by Jeffrey Xiong on 10/18/15.
//  Copyright © 2015 Rice Apps. All rights reserved.
//

import Foundation
import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var weight: UITextField?
    @IBOutlet weak var sex: UISegmentedControl?
    @IBOutlet weak var time: UITextField?
    @IBOutlet weak var alcType: UISegmentedControl?
    @IBOutlet weak var shotsTaken: UITextField?
    @IBOutlet weak var bac: UILabel?
    @IBOutlet weak var totalDrinks: UILabel?
    
    
    // Wedmark formula variables
    var totalAlcohol: Double = 0.0
    var bodyWater: Double?
    var waterConstant: Double?
    var metabolism: Double?
    var numDrinks: Double = 0.0
    // formula constants
    let LB_TO_KG = 0.453592             // conversion factor pounds (LB) to grams (g)
    let SCALE_FACTOR = 1.2              // scale factor given by Swedish National Institue of Public Health
    let BLOOD_WATER_CONSTANT = 0.806    // constant for body water in blood
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clear(sender: UIButton){
        totalAlcohol = 0;
        numDrinks = 0.0;
        totalDrinks?.text = String(format: "%.1f", numDrinks);
        self.updateBAC();
    }
    
    /*
    Calculate BAC as according to 2009 Paper:
    http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2724514/
    
    Widmark Formula:
    BAC = (BW * D * 1.2) / (BM * W) - (MR * P)
    where:
    BW = body water in blood, 0.806
    D = # of standard drinks
    1.2 = scaling factor defined by Swedish National Institute of Public Health
    BM = body mass
    W = body water constant (0.49 for women, 0.58 for men)
    MR = average metabolic rate (0.017 for women, 0.015 for men)
    P = drinking period in hours
    */
    
    func updateBAC(){
        
        // Get time
        if let elapsedTime = self.time?.text {
            if elapsedTime.isEmpty {
                print("BAC: No time was provided")
            } else {
                // Compute first half
                var bac = BLOOD_WATER_CONSTANT * totalAlcohol * SCALE_FACTOR / bodyWater!
                // Compute second half
                bac -= metabolism! * Double(elapsedTime)!
                // If invalid, display 0
                bac = (bac >= 0 || bac < 1) ? bac : 0;
                // Update label
                self.bac?.text = String(format: "%.2f", bac);
            }
        }
    }
    
    @IBAction func updateInfo(sender: UIButton) {
        
        // Get weight and sex
        if let weightInLb = self.weight!.text {
            if weightInLb.isEmpty {
                print("BAC: No weight was provided")
            } else {
                let weightInGrams = Double(weightInLb)! * LB_TO_KG
                if let sex = self.sex?.selectedSegmentIndex {
                    // 0.58 for male, 0.49 for female
                    waterConstant = Double(sex == 0 ? 0.58 : 0.49)
                    // 0.015 for male, 0.017 for female
                    metabolism = Double(sex == 0 ? 0.015 : 0.017)
                    bodyWater = Double(weightInGrams * waterConstant! * 1.2)
                }
            }
        }
        self.updateBAC()
    }

    @IBAction func addDrink(sender: UIButton){
        
        // Get type of alcohol
        if let alcType = self.alcType?.selectedSegmentIndex {
            var alcContent = 0.0;
            var alcAmount = 0.0;
            
            // Get respective data
            switch(alcType) {
            case 0:
                alcContent = 0.45
                alcAmount = 12
                break
            case 1:
                alcContent = 0.125
                alcAmount = 5
                break
            case 2:
                alcContent = 0.4
                alcAmount = 1.5
                break
            default:
                break
            }
            
            // Calculate total alcohol consumption
            if let drinksTaken = self.shotsTaken?.text {
                if drinksTaken.isEmpty {
                    print("BAC: Number of drinks was not indicated.")
                } else {
                    print(drinksTaken)
                    totalAlcohol += alcContent * alcAmount * Double(drinksTaken)!
                    numDrinks += Double(drinksTaken)!
                    totalDrinks?.text = String(format: "%.1f", numDrinks);
                    self.updateBAC()
                }
            }
        }
    }
    
}
