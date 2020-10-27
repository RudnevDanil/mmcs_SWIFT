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
        maxFractDigits = frac
        maxInpLen = len
    }
    
    public var result: Double?
    
    public var operation: Operation?
    
    public var input: Double?
    
    public func addDigit(_ d: Int) -> Bool
    {
        if hasPoint
        {
            if fractionDigits < maxFractDigits
            {
                var mult = 1.0
                for _ in 0...fractionDigits
                {
                    mult *= 10
                }
                input = (input ?? 0) +  Double(d) / mult
                fractionDigits += 1
            }
            else
            {
                return false
            }
        }
        else
        {
            if input == nil
            {
                if d == 0
                {
                    return false
                }
                input = 0
            }
            if String(format: "%.0f", input!).count < maxInpLen
            {
                input = input! * 10 + Double(d)
            }
            else
            {
                return false
            }
        }
        return true
    }
    
    public func addPoint()
    {
        hasPoint = true
        fractionDigits = 0
        if input == nil
        {
            input = 0
        }
    }
    
    public var hasPoint: Bool
    
    public var fractionDigits: UInt
    
    public let maxFractDigits: UInt
    
    public let maxInpLen: UInt
    
    public func unarOperation(_ op: Operation)
    {
        switch op
        {
            case Operation.perc:
                if (result != nil && input != nil)
                {
                    input = result! / 100 * input!
                }
            case Operation.sign:
                if input != nil
                {
                    input! *= -1
                }
                else if result != nil
                {
                    result! *= -1
                }
            default:
                print("Error unar operation")
        }
        
    }
    
    public func addOperation(_ op: Operation)
    {
        operation = op
        if result == nil
        {
            result = 0
        }
        
        if input != nil
        {
            result = input!
        }
        input = nil
        fractionDigits = 0
        hasPoint = false
    }
    
    public func compute() -> Bool
    {
        var isDivNull = false
        if operation == nil || result == nil || input == nil
        {
            reset()
        }
        else
        {
            // here computing result operation input. result will be in result
            switch operation!
            {
            case Operation.add:
                result! += input!
            case Operation.sub:
                result! -= input!
            case Operation.mul:
                result! *= input!
            case Operation.div:
                if input! == 0
                {
                    isDivNull = true
                }
                else
                {
                    result! /= input!
                }
            default:
                print("Unknown operation \(operation!)")
            }
            
            input = nil
            fractionDigits = 0
            hasPoint = false
        }
        if isDivNull
        {
            return false
        }
        return true
    }

    
    public func clear()
    {
        input = nil
        hasPoint = false
        fractionDigits = 0
    }
    
    public func reset()
    {
        result = nil
        operation = nil
        clear()
    }
    
}
