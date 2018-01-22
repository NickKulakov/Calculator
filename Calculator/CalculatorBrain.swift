//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Peter on 1/7/18.
//  Copyright © 2018 Nick. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op
    {
        case Operand(Double)
        case UnaryOperation(String, (Double) -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case EmptyOperation(String, Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case.EmptyOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String: Op]()
    
    init() {
        func learnOp (op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(op: .BinaryOperation("×", *))
        learnOp(op: .BinaryOperation("+", +))
        learnOp(op: .BinaryOperation("÷") {$1 / $0})
        learnOp(op: .BinaryOperation("−") {$1 - $0})
        learnOp(op: .UnaryOperation("√", sqrt))
        learnOp(op: .UnaryOperation("sin") {sin($0)})
        learnOp(op: .UnaryOperation("cos") {cos($0)})
        learnOp(op: .EmptyOperation("𝝅", .pi))
        learnOp(op: .UnaryOperation("±") {-$0})
        
        //knownOps["×"] = Op.BinaryOperation("×", *)
        //knownOps["+"] = Op.BinaryOperation("+", +)
        //knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        //knownOps["−"] = Op.BinaryOperation("−") {$1 - $0}
        //knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    private func evaluate (ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_ , let operation):
                let operandEvaluation = evaluate(ops: remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_ , let operation):
                let op1Evaluation = evaluate(ops: remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(ops: op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .EmptyOperation(_ , let operation):
                return (operation, remainingOps)
            }
            
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(ops:opStack)
        if let res = result {
            print("\(opStack) = \(res) with \(remainder) left over")
        }
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}

