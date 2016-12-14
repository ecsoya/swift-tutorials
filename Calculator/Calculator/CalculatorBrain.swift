//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ecsoya on 14/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private var accumulator = 0.0
    
    private var pending: PendingBinaryOperationInfo?
    
    var result: Double{
        get{
            return accumulator
        }
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.Constants(M_PI),
        "e": Operation.Constants(M_E),
        "+": Operation.BinaryOperation({$0 + $1}),
        "−": Operation.BinaryOperation({$0 - $1}),
        "×": Operation.BinaryOperation({$0 * $1}),
        "÷": Operation.BinaryOperation({$0 / $1}),
        "=": Operation.Equals,
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "±": Operation.UnaryOperation({-$0})
    ]
    
    func setOperand(operand: Double){
        accumulator = operand
    }
    
    func performOperation(symbol: String){
        if let operation = operations[symbol] {
            switch operation {
            case .Constants(let value):
                accumulator = value
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    
    private struct PendingBinaryOperationInfo{
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private enum Operation{
        case Constants(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
}
