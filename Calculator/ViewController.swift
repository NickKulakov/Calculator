//
//  ViewController.swift
//  Calculator
//
//  Created by Peter on 1/4/18.
//  Copyright © 2018 Nick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    @IBAction func appendDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber == true {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(_ sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        case "×":
            performOperation{$0 * $1}
        case "÷":
            performOperation{$1 / $0}
            
        case "+":
            performOperation{$0 + $1}
        case "−":
            performOperation{$1 - $0}
        case "√":
            performOperation{sqrt($0)}
        default:
            break
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: (Double) -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack =  \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            var dispV = NSNumber()
            if let dispString = display.text {
                dispV = NSNumber(value: Double("\(dispString)")!)
            }
            return Double(truncating: dispV)
        }
        // equivalent code
        // NSNumber(value: Int("String")!)
        
        //            var dispVal = Double()
        //            if let displayString = display.text {
        //                if let displayDouble = Double(displayString) {
        //                    dispVal = displayDouble
        //                }
        //            }
        //            return dispVal
        //    }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

