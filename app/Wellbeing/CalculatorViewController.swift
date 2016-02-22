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
    @IBOutlet weak var hDrive: UILabel?
    @IBOutlet weak var hSober: UILabel?
    var totalAlcohol: Double = 0.0
    var bodyWater: Double?
    
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
        self.updateBAC();
    }
    
    @IBAction func updateSelf(sender: UIButton){
        //Get Inputs
        let weightKg = Double(self.weight!.text!)! * 0.453592;
        let percentWater = Double(self.sex?.selectedSegmentIndex == 0 ? 0.58 : 0.49);
        bodyWater = Double(weightKg * percentWater * 1000);
        
        self.updateBAC();
        
    }
    
    @IBAction func addShot(sender: UIButton){
        //Source: http://celtickane.com/projects/blood-alcohol-content-bac-calculator/
        //Open console and type "CalcBAC"
        
        //Update alcohol info
        let alcType = (self.alcType?.selectedSegmentIndex)!;
        var alcPercent = 0.0;
        var alcAmount = 0.0;
        switch(alcType){
        case 0 : //beer
            alcPercent = 4.5;
            alcAmount = 12;
            break;
        case 1: //wine
            alcPercent = 12.5;
            alcAmount = 5;
            break;
        case 2: //liquor
            alcPercent = 40;
            alcAmount = 1.5;
            break;
        default:
            break;
        }
        
        totalAlcohol += 0.01 * alcPercent * alcAmount * Double((self.shotsTaken?.text)!)!;
        
        self.updateBAC();
        
    }
    
    func updateBAC(){
        //Calculate BAC
        let metabolism = 0.017;
        let elapsedTime = Double((self.time?.text)!);
        var bac = totalAlcohol/bodyWater! * 23.36 * 0.806 * 100;
        // g/oz EtOH, water in blood
        bac -= metabolism * elapsedTime!; //average metabolism
        bac = bac >= 0 || bac < 1 ? bac : 0;
        var hDrive = (bac - 0.08) / metabolism;
        if hDrive < 0 {
            hDrive = 0;
        }
        let hSober  = bac / metabolism;
        
        self.bac?.text = String(format: "%.3f", bac);
        self.hDrive?.text = String(format: "%.1f", hDrive);
        self.hSober?.text = String(format: "%.1f", hSober);
        
    }
    
    /*
    #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
