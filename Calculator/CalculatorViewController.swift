//
//  ViewController.swift
//  Calculator
//
//  Created by Ernesto Cortez on 9/2/16.
//  Copyright © 2016 CSU, Monterey Bay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //# MARK: - Objects and Properties
    
    var brain = CalculatorBrain()
    var userTyping = false
    var decimalEntered = false
    
    //# MARK: - Display & History
 

    @IBOutlet weak var display: UILabel!
    
    
    @IBOutlet weak var history: UILabel!
    
    var displayValue: Double?{
        get {
            return Double(display.text!)!
        }
        set {
            if let result = newValue {
                display.text = String(result)
                history.text = brain.description + (brain.isPartialResult ? " ..." : " =")
            }
            else{
                display.text = "0"
                history.text = " "
                userTyping = false
                decimalEntered = false
            }
            
        }
    }

    
    //# MARK: - Button Methods

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
            brain.performOperation(operation)
        }
        displayValue = brain.result

    }
    
    
  
    @IBAction func clearCalc(sender: UIButton) {
        
        brain.clear()
        displayValue = nil
        userTyping = false
        decimalEntered = false
        
    }
    
    
    @IBAction func setM() {
        if let value = display.text {
            brain.setVariableValue(Double(value)!, variableName: "M")
        }
        
    }
    
    
    @IBAction func pushM(sender: UIButton) {
        if userTyping {
            brain.setOperand("M")
            userTyping = false
        }
        if let digit = brain.getVariableValue("M") {
            
                display.text! = String(digit)
        
        }

    
        
    }
    
    
    @IBAction func backSpace() {
        if userTyping  {
            display.text!.removeAtIndex(display.text!.endIndex.predecessor())
        }
        if display.text!.isEmpty {
            userTyping  = false
            displayValue = brain.result
        }
    }
 
    
}

