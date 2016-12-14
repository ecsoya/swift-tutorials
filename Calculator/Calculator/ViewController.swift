//
//  ViewController.swift
//  Calculator
//
//  Created by Ecsoya on 14/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
}

