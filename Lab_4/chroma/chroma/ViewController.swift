//
//  ViewController.swift
//  chroma
//
//  Created by Admin on 05/11/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var redColor: UISlider!
    @IBOutlet weak var greenColor: UISlider!
    @IBOutlet weak var blueColor: UISlider!
    @IBOutlet weak var colorLabel: RoundButton!
    
    @IBAction func coloralueChanged(_ sender: Any)
    {
        colorLabel.backgroundColor =  UIColor(red: (CGFloat(redColor.value/255.0)), green: (CGFloat(greenColor.value/255.0)), blue: (CGFloat(blueColor.value/255.0)), alpha: 1.0)
    }
    
    @IBAction func buttonLoadTouched(_ sender: Any)
    {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false // ???
        self.present(image, animated: true)
        {
            // After it is completed
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imageView.image = image
        }
        else
        {
            // error message
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func ButtonEraserTouched(_ sender: Any)
    {
        
    }
    
    @IBAction func buttonSaveTouched(_ sender: Any)
    {
        
    }
    
    
    
}

