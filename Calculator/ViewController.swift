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
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var tochka: UIButton! {
        didSet{
            tochka.setTitle(decimalSeparator, for: UIControlState.normal)
        }
    }
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    let decimalSeparator = NumberFormatter().decimalSeparator ?? "."
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            //попытаемся заблокировать повторный ввод десятичного разделителя
            if (digit == decimalSeparator) && (display.text?.range(of: decimalSeparator)) != nil {return}
            //уничтожаем лидирующие нули
            if (digit == "0") && ((display.text == "0") || (display.text == "-0")) {return}
            if (digit != decimalSeparator) && ((display.text == "0") || (display.text == "-0")) {display.text = "0" + digit; return}
            //-------------------------------------------------------------------
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
            addHistory(text: operation + "=")
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
        addHistory(text: display.text!)
    }
    
    @IBAction func plusMinus(_ sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            if (display.text!.range(of: "-") != nil) {
                display.text = String(display.text!.dropFirst())
            } else {
                display.text = "-" + display.text!
            }
        } else {
             operate(sender)
        }
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        displayValue = 0
        history.text = " "
    }
    
    @IBAction func backSpace(_ sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            if display.text?.count != 1 {
                display.text = String(describing: display.text!.dropLast())
            } else {
               displayValue = 0
            }
        }
    }
    
    func addHistory(text: String) {
        if history.text!.range(of: "=") != nil {
            history.text = String(history.text!.dropLast())
        } else {
            history.text = history.text
        }
        history.text = history.text! + " " + text
    }
    
    var displayValue: Double {
        get {
            var dispV = NSNumber()
            
            if let dispString = display.text {
                dispV = NSNumber(value: Double("\(dispString)")!)
            }
            return Double(truncating: dispV)
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

