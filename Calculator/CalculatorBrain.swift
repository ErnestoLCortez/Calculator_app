//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by louie on 9/8/16.
//  Copyright © 2016 CSU, Monterey Bay. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    //# MARK: - Number Accumulator
    
    private var accumulator: Double = 0.0
    
    func setOperand(operand: Double){
        accumulator = operand
        descriptionAccumulator = String(accumulator)
    }
    
    func setOperand(variableName: String){
        if let operand = variableValues[variableName] {
            accumulator = operand
            descriptionAccumulator = variableName
        }
        
    }

    
    var result: Double {
        get{
            return accumulator
        }
    }
    
    //#MARK: - String Accumulator
    
    var description: String {
        get {
            if pending == nil {
                return descriptionAccumulator
            }
            else {
                if(pending!.descriptionOperand != descriptionAccumulator){
                    return pending!.descriptionFunction(pending!.descriptionOperand, descriptionAccumulator)
                }
                return pending!.descriptionFunction(pending!.descriptionOperand, "")
            }
        }
    }
    
    private var currentPrecedence = Int.max
    
    private var descriptionAccumulator = "0" {
        didSet {
            if pending == nil {
                currentPrecedence = Int.max
            }
        }
    }
    
    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
    //# MARK: - Variables
    
    
    private var variableValues: Dictionary<String, Double> = [
        "x" : 35.0,
        "y" : 25.0
    ]
    
    func setVariableValue(variableValue: Double, variableName: String){
        variableValues.updateValue(variableValue, forKey: variableName)
    }
    
    func getVariableValue(variableName: String) -> Double? {
        return variableValues[variableName]
    }
    
    
    //# MARK: - Operations
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double, (String) -> String)
        case BinaryOperation((Double, Double) -> Double, (String, String) -> String, Int)
        case Equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt,{ "√(" + $0 + ")"}),
        "cos" : Operation.UnaryOperation(cos, { "cos(" + $0 + ")"}),
        "sin" : Operation.UnaryOperation(sin, { "sin(" + $0 + ")"}),
        "×" : Operation.BinaryOperation(*, { $0 + " × " + $1 }, 1),
        "/" : Operation.BinaryOperation(/, { $0 + " / " + $1 }, 1),
        "+" : Operation.BinaryOperation(+, { $0 + " + " + $1 }, 0),
        "-" : Operation.BinaryOperation(-, { $0 + " - " + $1 }, 0),
        "=" : Operation.Equals
        
    ]
    
    
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
                descriptionAccumulator = symbol
            case .UnaryOperation(let function, let descriptionFunction):
                accumulator = function(accumulator)
                descriptionAccumulator = descriptionFunction(descriptionAccumulator)
            case .BinaryOperation(let function, let descriptionFunction, let precedence):
                executePendingBinaryOperation()
                if currentPrecedence < precedence {
                    descriptionAccumulator = "(" + descriptionAccumulator + ")"
                }
                currentPrecedence = precedence
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator, descriptionFunction: descriptionFunction, descriptionOperand: descriptionAccumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    //# MARK - Pending Operations
    
    private func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            descriptionAccumulator = pending!.descriptionFunction(pending!.descriptionOperand, descriptionAccumulator)
            pending = nil
        }

    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        var descriptionFunction: (String, String) -> String
        var descriptionOperand: String
    }
    
    
    
    
    
    
    //# MARK: Clear
    
    
    func clear(){
        accumulator = 0.0
        pending = nil
        descriptionAccumulator = " "
        currentPrecedence = Int.max
        
        if(variableValues["M"] != nil){
            variableValues.removeValueForKey("M")
        }
    }
    
}
