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
            display.text = display.text! + digit
        } else {
            display.text = digit
            userTyping = true
        }
        
    }
    
    @IBAction func appendDecimal(sender: UIButton) {
        
        if !decimalEntered {
            appendDigit(sender)
            decimalEntered = true
        }
    }
    
    

    @IBAction func operate(sender: UIButton) {
        if userTyping {
            enter()
        }

        if let operation = sender.currentTitle {
            historyValue += operation
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }

    }
    
  
    @IBAction func clearCalc(sender: UIButton) {
        
        displayValue = 0
        historyValue = ""
        brain.clearStack()
        userTyping = false
        decimalEntered = false
        
    }
    
 
    
    @IBAction func enter() {
        userTyping = false
        
        historyValue += String(displayValue)
        
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    var displayValue: Double{
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userTyping = false
            decimalEntered = false
        }
    }
    
    var historyValue: String {
        get {
            return history.text!
        }
        set {
            history.text = "\(newValue) "
        }
    }
}

