//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Scott Khamphoune on 12/6/15.
//  Copyright © 2015 Scott Khamphoune. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    // Op implements the CustomStringConvertible protocol by having the description property
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        knownOps["x"] = Op.BinaryOperation("x", *)
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["-"] = Op.BinaryOperation("-") {$1 - $0}
        knownOps["⎷"] = Op.UnaryOperation("⎷", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["π"] = Op.Operand(M_PI)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops // mutable copy of immutable op
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvalution = evaluate(remainingOps)
                if let operand = operandEvalution.result {
                    return (operation(operand), operandEvalution.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evalution = evaluate(remainingOps)
                if let operand1 = op1Evalution.result {
                    let op2Evaluation = evaluate(op1Evalution.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            // don't need a "default: break" because we've handled every case of what Op can be
            }
        }
        return (nil, ops)
    }
    
    func evaluate () -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        // operation is an Optional because symbol may not be in knownOps
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func reset() {
        opStack.removeAll()
    }
}