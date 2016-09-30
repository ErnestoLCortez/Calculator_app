//
//  ViewController.swift
//  Calculator
//
//  Created by Ernesto Cortez on 9/2/16.
//  Copyright © 2016 CSU, Monterey Bay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    
    var userTyping = false
    var decimalEntered = false
    
    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userTyping{
            display.text! = display.text! + digit
        } else {
            display.text! = digit
            
        }
        userTyping = true
        
    }
    
    @IBAction func appendDecimal(sender: UIButton) {
        
        if !decimalEntered {
            appendDigit(sender)
            decimalEntered = true
        }
    }
    
    

    @IBAction func operate(sender: UIButton) {
        if userTyping {
            
            brain.setOperand(displayValue!)
            userTyping = false
        }

        if let operation = sender.currentTitle {
            updateHistory(String(displayValue!), operation: operation)
            brain.performOperation(operation)
        }
        displayValue = brain.result

    }
    
    func updateHistory(operand: String, operation: String) {
        brain.description += String(displayValue!)
        if operation != "=" {
            brain.description += operation
        }
        history.text! = brain.description
        if brain.isPartialResult{
            history.text! += "..."
        }
        else {
            history.text! += "="
        }
    }
  
    @IBAction func clearCalc(sender: UIButton) {
        
        brain.clear()
        userTyping = false
        decimalEntered = false
        
    }
    
 
   
    
    var displayValue: Double?{
        get {
            return Double(display.text!)!
        }
        set {
            if let result = newValue {
                display.text! = String(result)
            }
            else{
                display.text! = "0"
            }
            userTyping = false
            decimalEntered = false
        }
    }
    
    
        /*
        get {
            return history.text!
        }
        set {
            history.text = "\(newValue) "
        }
    }*/
}

