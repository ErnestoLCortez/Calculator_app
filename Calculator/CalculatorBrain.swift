//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by louie on 9/8/16.
//  Copyright © 2016 CSU, Monterey Bay. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    enum Op: CustomStringConvertible {
        case Operand(Double)
        case VariableOperand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .VariableOperand(let operand):
                    return "\(operand)"
                case.UnaryOperation(let symbol, _):
                    return symbol
                case.BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        
        knownOps["×"] = Op.BinaryOperation("×"){$0 * $1}
        knownOps["/"] = Op.BinaryOperation("/"){$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+"){$0 + $1}
        knownOps["-"] = Op.BinaryOperation("-"){$1 - $0}
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["π"] = Op.VariableOperand(M_PI)
    }
    
    typealias PropertyList = AnyObject
    
    var program: AnyObject { //guaranteed to be a PropertyList
        get {
            return opStack.map { $0.description}
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
                case .Operand(let operand):
                    return (operand, remainingOps)
                case .UnaryOperation(_, let operation):
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result {
                        return (operation(operand), operandEvaluation.remainingOps)
                    }
                case .BinaryOperation(_, let operation):
                    let op1Evaluation = evaluate(remainingOps)
                    if let operand1 = op1Evaluation.result {
                        let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2Evaluation.result {
                            return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        }
                    }
                case .VariableOperand(let operand):
                    return (operand, remainingOps)
            }
        }
        return (nil, ops)
        
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
        
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clearStack() {
        opStack.removeAll()
    }
    
}