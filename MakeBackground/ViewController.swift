//
//  ViewController.swift
//  MakeBackground
//
//  Created by Pinlun on 2020/6/4.
//  Copyright © 2020 PINLUNDEV. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var chooseColorButton: UIButton!
    @IBOutlet weak var choosePhotoButton: UIButton!
    
    var colorView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    func setUpView() {
        chooseColorButton.backgroundColor = #colorLiteral(red: 0.1088050976, green: 0.7243837118, blue: 0.331433624, alpha: 1)
        chooseColorButton.tintColor = .white
        chooseColorButton.layer.cornerRadius = 25.0
        chooseColorButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        chooseColorButton.setTitle(NSLocalizedString("chooseColor", comment: ""),for: .normal)
        
        choosePhotoButton.backgroundColor = #colorLiteral(red: 0.1088050976, green: 0.7243837118, blue: 0.331433624, alpha: 1)
        choosePhotoButton.tintColor = .white
        choosePhotoButton.layer.cornerRadius = 25.0
        choosePhotoButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        choosePhotoButton.setTitle(NSLocalizedString("choosePhoto", comment: ""),for: .normal)
    }
    
    @IBAction func chooseColorClick(_ sender: Any) {
        
        self.colorView.frame.size.width = self.view.safeAreaLayoutGuide.layoutFrame.size.width
        self.colorView.frame.size.height = UIScreen.main.bounds.height
        self.colorView.backgroundColor = .black
        
        let renderer = UIGraphicsImageRenderer(size: self.colorView.bounds.size)
        let image = renderer.image { ctx in
            self.colorView.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        
        DispatchQueue.main.async {
            self.view.insertSubview(self.colorView, at: 0)
        }

        
        
    }
    


}

