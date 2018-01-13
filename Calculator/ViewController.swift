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
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(_ sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(symbol: operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(operand: displayValue) {
            displayValue = result
        } else {
            //error ?
            displayValue = 0 // the task № 2
        }
        //        operandStack.append(displayValue)
        //        print("operandStack =  \(operandStack)")
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

