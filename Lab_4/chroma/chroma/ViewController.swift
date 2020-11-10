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
        //view = imageView!
        //view = UIImageView(frame: view.bounds)
        //view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        
        let press = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        view.addGestureRecognizer(press)
    }

    var taped = false
    var lastPoint = CGPoint.zero
    var strokeWidth: CGFloat = 12.0
    var strokeColor = UIColor.blue
    var linePath: UIBezierPath?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var redColor: UISlider!
    @IBOutlet weak var greenColor: UISlider!
    @IBOutlet weak var blueColor: UISlider!
    @IBOutlet weak var colorLabel: RoundButton!
    var imageViewLines: UIImageView {
        return imageView!
        //return view as! UIImageView
    }
    
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
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    @IBAction func ButtonEraserTouched(_ sender: Any)
    {
        
    }
    
    @IBAction func buttonSaveTouched(_ sender: Any)
    {
        guard let image = imageView.image else { print("error 1"); return }        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        taped = true
        if let touch = touches.first {
            //lastPoint = touch.location(in: view)
            lastPoint = touch.location(in: imageViewLines)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        taped = false
        if let touch = touches.first {
            //let currentPoint = touch.location(in: view)
            let currentPoint = touch.location(in: imageViewLines)
            drawLine(from: lastPoint, to: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if taped {
            drawLine(from: lastPoint, to: lastPoint)
        }
    }
    
    @objc func longPress() {
        let activity = UIActivityViewController(activityItems: [imageViewLines.image as Any], applicationActivities: nil)
        present(activity, animated:true, completion:nil)
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint:CGPoint) {
        
        //UIGraphicsBeginImageContext(view.frame.size)
        UIGraphicsBeginImageContext(imageViewLines.frame.size)
        
        //imageViewLines.image?.draw(in: CGRect(origin: CGPoint.zero, size: view.frame.size))
        /*let stPoint = CGPoint(
            x: (imageViewLines.frame.origin.x - imageViewLines.frame.size.width / 2),
            y: (imageViewLines.frame.origin.y - imageViewLines.frame.size.height / 2))*/
        let stPoint = CGPoint(
            x: (imageViewLines.frame.origin.x),
            y: (imageViewLines.frame.origin.y))
        
        let imSize = CGSize(
            width: imageViewLines.frame.size.width + imageViewLines.frame.size.width - floor(imageViewLines.frame.size.width),
            height: imageViewLines.frame.size.height + imageViewLines.frame.size.height - floor(imageViewLines.frame.size.height))
        imageViewLines.image?.draw(in: CGRect(origin: stPoint, size: imSize))
        //imageViewLines.image?.draw(in: CGRect(origin: stPoint, size: view.frame.size))
        
        let linePath = UIBezierPath()
        
        linePath.move(to: fromPoint)
        linePath.addLine(to: toPoint)
        
        strokeColor.setStroke()
        linePath.lineWidth = strokeWidth
        linePath.lineCapStyle = .round
        linePath.lineJoinStyle = .round
        linePath.stroke()
        
        imageViewLines.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

