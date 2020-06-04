//
//  ColorPickerViewController.swift
//  MakeBackground
//
//  Created by Pinlun on 2020/6/4.
//  Copyright © 2020 PINLUNDEV. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {

    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var pickedColor: UIView!
    @IBOutlet weak var okButton: UIButton!
    
    var delegate: ModalDelegate?
    
    var chosenImage: UIImage?
    var chosenColor: UIColor?
    var touchLocation: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
//        self.pickedImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickColor(tapGestureRecognizer:))))
    }
    
    func setUpView() {
        self.pickedImage.image = chosenImage
        pickedColor.layer.cornerRadius = 30
        pickedColor.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pickedColor.layer.borderWidth = 3
        okButton.setTitle("OK", for: .normal)
        okButton.setTitle("OK", for: .highlighted)
        okButton.backgroundColor = #colorLiteral(red: 0.1088050976, green: 0.7243837118, blue: 0.331433624, alpha: 1)
        okButton.tintColor = .white
        okButton.layer.cornerRadius = 20.0
        okButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
        if let delegate = self.delegate {
            if self.chosenColor != nil {
                delegate.finishedPickingColor(value: self.chosenColor!)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
//    @objc func pickColor(tapGestureRecognizer: UITapGestureRecognizer) {
//        self.chosenColor = pickedImage.image?.getPixelColor(atLocation: self.touchLocation ?? CGPoint(x: 0, y: 0), withFrameSize: pickedImage.frame.size)
//        print(self.chosenColor)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.pickedImage.backgroundColor = self.chosenColor
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            self.touchLocation = touch.location(in: self.pickedImage)
            print(touchLocation!.x)
            print(touchLocation!.y)
            self.chosenColor = pickedImage.image?.getPixelColor(atLocation: self.touchLocation ?? CGPoint(x: 0, y: 0), withFrameSize: pickedImage.frame.size)
            DispatchQueue.main.async {
                self.pickedColor.backgroundColor = self.chosenColor
            }
        }
    }

}

