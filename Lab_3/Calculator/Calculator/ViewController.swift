//
//  ViewController.swift
//  Calculator
//
//  Created by Admin on 26/10/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var outLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func buttonTouched(_ sender: RoundButton)
    {
        
        outLabel.text = sender.titleLabel?.text
    }

}

