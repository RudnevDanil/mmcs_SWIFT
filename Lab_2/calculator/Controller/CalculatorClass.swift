//
//  CalculatorClass.swift
//  calculator
//
//  Created by Admin on 20/10/2020.
//  Copyright © 2020 Илья Лошкарёв. All rights reserved.
//

import Foundation

public class CalculatorClass: Calculator
{
    public var delegate: CalculatorDelegate?
    
    public required init(inputLength len: UInt, maxFraction frac: UInt)
    {
        //delegate = nil
        result = nil
        operation = nil
        input = nil
        hasPoint = false
        fractionDigits = 0
    }
    
    public var result: Double?
    
    public var operation: Operation?
    
    public var input: Double?
    
    public func addDigit(_ d: Int)
    {
        
    }
    
    public func addPoint()
    {
        
        
    }
    
    public var hasPoint: Bool
    
    public var fractionDigits: UInt
    
    public func addOperation(_ op: Operation)
    {
        
    }
    
    public func compute()
    {
        
    }
    
    public func clear()
    {
        
    }
    
    public func reset()
    {
        
    }
    
}
