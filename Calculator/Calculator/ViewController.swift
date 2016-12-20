//
//  ViewController.swift
//  Calculator
//
//  Created by Ecsoya on 14/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import UIKit

var calculatorCount = 0

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Try to look at the memory heap for calculators
        calculatorCount += 1
        print("Loaded up a new Calculator (count = \(calculatorCount))")
        
        //Add clouse and watch it
        brain.addUnaryOperation(symbol: "Z") { [weak weakSelf = self] in //this is important to release heap [unowned ...]
            weakSelf?.display.textColor = UIColor.red
            return sqrt($0)
        }
    }
    
    deinit {
        calculatorCount -= 1
        print("Calculator left the heap (count = \(calculatorCount))")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toughDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        let textCurrentlyInDisplay = display.text!
        if (userIsInTheMiddleOfTyping){
            display.text = textCurrentlyInDisplay + digit
        }else{
            display.text = sender.currentTitle
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping{
            brain.setOperand(operand: displayValue)
        }
        userIsInTheMiddleOfTyping = false
        if let value = sender.currentTitle {
            brain.performOperation(symbol: value)
        }
        displayValue = brain.result
    }
    
    private var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
            print("Restored: \(savedProgram), \(displayValue)")
        }
    }
    @IBAction func save() {
        savedProgram = brain.program
        print("Saved: \(savedProgram)" )
    }
}

