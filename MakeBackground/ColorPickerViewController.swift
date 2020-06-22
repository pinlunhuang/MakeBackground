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
    }
    
    func setUpView() {
        self.pickedImage.image = chosenImage
        pickedColor.layer.cornerRadius = 30
        pickedColor.layer.borderColor = UIColor(named: "pickedColorBorder")?.cgColor
        pickedColor.layer.borderWidth = 2.2
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: self.pickedImage) {
            let color = pickedImage.getPixelColorAt(point: point)
            print(color)
            DispatchQueue.main.async {
                self.pickedColor.backgroundColor = color
                self.chosenColor = color
            }
        }
    }

}

