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
    
    var userTyping = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userTyping{
            display.text = display.text! + digit
        } else {
            display.text = digit
            userTyping = true
        }
        
    }

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userTyping{
            enter()
        }
        switch operation {
        case "×": performOperation{ $0 * $1 }
        case "÷": performOperation{ $1 / $0 }
        case "+": performOperation{ $0 + $1 }
        case "−": performOperation{ $1 - $0 }
        case "√": performOperation{ sqrt($0) }
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: (Double) -> Double){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userTyping = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double{
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userTyping = false
        }
    }
}

