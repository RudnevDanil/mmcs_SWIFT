//
//  ViewController.swift
//  Calculator
//
//  Created by Admin on 26/10/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var outputLabel: UILabel!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Calculator"
        
        // Обращаемся к созданному калькулятору
        calculator = (UIApplication.shared.delegate as! AppDelegate).calculator
        // Становимся представителем
        calculator?.delegate = self
        // Очищаем состояние калькулятора
        calculator?.reset();
        
        // Выводим число с одной цифрой
        formatter.minimumIntegerDigits = 1
    }
    
    weak var calculator: Calculator?
    
    let formatter = NumberFormatter()
    let maximumFractionDigits = 5
    
    @IBAction func buttonTouched(_ sender: RoundButton)
    {
        let contentOpt = sender.titleLabel?.text
        if contentOpt == nil
        {
            outputLabel.text = "Unresolved error"
            return
        }
        
        let content = contentOpt!
        
        switch content
        {
            
        case "0"..."9":
            outputLabel.text? += content
            let res = calculator?.addDigit(Int(content)!)
            if res != nil && res!
            {
                calculatorDidUpdateValue(calculator!, with: calculator?.input ?? 0, valuePrecision: calculator?.fractionDigits ?? 0)
            }
            else
            {
                var str = outputLabel.text
                str?.removeLast()
                outputLabel.text = str
                calculatorDidInputOverflow(calculator!)
            }
            
        case formatter.decimalSeparator:
            outputLabel.text? += "."
            calculator?.addPoint()
            calculatorDidUpdateValue(calculator!, with: calculator?.input ?? 0, valuePrecision: calculator?.fractionDigits ?? 0)
            
        case "C":
            outputLabel.text? = ""
            if let _ = calculator?.input {
                calculator?.clear();
            } else {
                calculator?.reset();
            }
            calculatorDidUpdateValue(calculator!, with: calculator?.input ?? 0, valuePrecision: calculator?.fractionDigits ?? 0)
        case "±", "%":
            calculator?.unarOperation(Operation(rawValue:content)!)
            calculatorDidUpdateValue(calculator!, with: calculator?.input ?? (calculator?.result ?? 0), valuePrecision: calculator?.fractionDigits ?? 0)
        case "+", "-", "*", "÷":
            calculator?.addOperation(Operation(rawValue:content)!)
            calculatorDidUpdateValue(calculator!, with: calculator?.result ?? 0, valuePrecision: calculator?.fractionDigits ?? 0)
        case "=":
            let res = calculator?.compute()
            if res != nil && res!
            {
                calculatorDidUpdateValue(calculator!, with: calculator?.result ?? 0, valuePrecision: calculator?.fractionDigits ?? 0)
            }
            else
            {
                calculatorDidNotCompute(calculator!, withError: "error")
            }
        default:
            outputLabel.text = "Unresolved button"
        }
    }

}

