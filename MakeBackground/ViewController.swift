//
//  ViewController.swift
//  MakeBackground
//
//  Created by Pinlun on 2020/6/4.
//  Copyright © 2020 PINLUNDEV. All rights reserved.
//

import UIKit
import JGProgressHUD

class ViewController: UIViewController, UINavigationControllerDelegate, ModalDelegate {
    
    @IBOutlet weak var saveImageButton: UIButton!
    @IBOutlet weak var choosePhotoButton: UIButton!
    
    var colorView = UIView()
    var chosenColor: UIColor?
    var photoForPickingColor: UIImage?
    
    let galleryController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.chosenColor == nil {
            self.saveImageButton.isHidden = true
        } else {
            self.saveImageButton.isHidden = false
        }
    }
    
    func setUpView() {
        saveImageButton.backgroundColor = #colorLiteral(red: 0.1088050976, green: 0.7243837118, blue: 0.331433624, alpha: 1)
        saveImageButton.tintColor = .white
        saveImageButton.layer.cornerRadius = 25.0
        saveImageButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        saveImageButton.setTitle(NSLocalizedString("saveImage", comment: ""),for: .normal)
        
        choosePhotoButton.backgroundColor = #colorLiteral(red: 0.1088050976, green: 0.7243837118, blue: 0.331433624, alpha: 1)
        choosePhotoButton.tintColor = .white
        choosePhotoButton.layer.cornerRadius = 25.0
        choosePhotoButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        choosePhotoButton.setTitle(NSLocalizedString("choosePhoto", comment: ""),for: .normal)
    }
    
    @IBAction func saveImageClick(_ sender: Any) {
        
        self.colorView.frame.size.width = self.view.safeAreaLayoutGuide.layoutFrame.size.width
        self.colorView.frame.size.height = UIScreen.main.bounds.height
        self.colorView.backgroundColor = self.chosenColor
        
        let renderer = UIGraphicsImageRenderer(size: self.colorView.bounds.size)
        let image = renderer.image { ctx in
            self.colorView.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }

        DispatchQueue.main.async {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @IBAction func choosePhotoClick(_ sender: Any) {
        self.accessGallery()
    }
    
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
    
    //MARK: - Save Image callback

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            let hud = JGProgressHUD.init(style: .dark)
            hud.indicatorView = nil
            hud.textLabel.text = NSLocalizedString("saveError", comment: "")
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        } else {
            let hud = JGProgressHUD.init(style: .dark)
            hud.textLabel.text = NSLocalizedString("saveSuccess", comment: "")
            hud.indicatorView = nil
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    //MARK: - Access Gallery
    
    func accessGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            galleryController.delegate = self
            galleryController.allowsEditing = false
            galleryController.sourceType = .photoLibrary
            self.present(galleryController, animated: true, completion: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPickedImage" {
            let pickerVC = segue.destination as! ColorPickerViewController
            pickerVC.chosenImage = self.photoForPickingColor
            pickerVC.delegate = self
            pickerVC.isModalInPresentation = true
        }
    }
    
    @IBAction func haveChooseColor(sender: UIStoryboardSegue) {
        if let cpVC = sender.source as? ColorPickerViewController {
            self.chosenColor = cpVC.chosenColor
            DispatchQueue.main.async {
                self.view.backgroundColor = self.chosenColor
            }
        }
    }
    
    func finishedPickingColor(value: UIColor) {
        self.chosenColor = value
        self.saveImageButton.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.view.backgroundColor = self.chosenColor
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        self.photoForPickingColor = chosenImage
        print(chosenImage.size)
        if self.photoForPickingColor != nil {
            self.performSegue(withIdentifier: "showPickedImage", sender: self)
            
        }
    }
}

extension UIImageView {
    func getPixelColorAt(point:CGPoint) -> UIColor{
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        layer.render(in: context!)
        let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                    green: CGFloat(pixel[1])/255.0,
                                    blue: CGFloat(pixel[2])/255.0,
                                    alpha: CGFloat(pixel[3])/255.0)
        
//        pixel.deallocate()
        return color
    }
}

protocol ModalDelegate {
    func finishedPickingColor(value: UIColor)
}

