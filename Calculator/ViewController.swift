//
//  ViewController.swift
//  Calculator
//
//  Created by Scott Khamphoune on 12/1/15.
//  Copyright © 2015 Scott Khamphoune. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if digit != "." || display.text!.rangeOfString(".") == nil {
            if (userIsInTheMiddleOfTypingANumber) {
                display.text = display.text! + digit
            } else {
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
            }
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            historyValue = operation
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func enter() {
        if userIsInTheMiddleOfTypingANumber {
            historyValue = displayValue == nil ? "" : String(displayValue!)
        }
        userIsInTheMiddleOfTypingANumber = false
        if displayValue != nil {
            if let result = brain.pushOperand(displayValue!) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func reset() {
        userIsInTheMiddleOfTypingANumber = false
        brain.reset()
        history.text = ""
        displayValue = nil
    }
    
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            display.text = newValue == nil ? "" : "\(newValue!)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    var historyValue : String {
        get {
            return history.text!
        }
        set {
            if history.text?.isEmpty ?? true {
                history.text = "\(newValue)"
            } else {
                history.text = history.text! + " \(newValue)"
            }
        }
    }

}

