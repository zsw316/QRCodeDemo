//
//  ViewController.swift
//  QRCodeDemo
//
//  Created by Ashley Han on 16/09/17.
//  Copyright © 2017 simpletask. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {

    @IBOutlet weak var generateQRCodeButton: UIButton!
    @IBOutlet weak var scanQRCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "QRCode Demo"
        
        generateQRCodeButton.addTarget(self, action: #selector(ViewController.didTapGenerateQRCodeButton(button:)), for: .touchUpInside);
        
        scanQRCodeButton.addTarget(self, action: #selector(ViewController.didTapScanQRCodeButton(button:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didTapGenerateQRCodeButton(button: UIButton) -> Void {
        let generateQRCodeViewController = GenerateQRCodeViewController()
        self.navigationController?.pushViewController(generateQRCodeViewController, animated: true)
    }
    
    func didTapScanQRCodeButton(button: UIButton) -> Void {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary))
        {
            let imagePickerVC = UIImagePickerController()
            imagePickerVC.sourceType = .photoLibrary
            imagePickerVC.mediaTypes = [String(kUTTypeImage)]
            imagePickerVC.delegate = self
            imagePickerVC.allowsEditing = false
            self.present(imagePickerVC, animated: true, completion: nil)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: false, completion: nil)
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let ciImage:CIImage=CIImage(image:image)!
        let context = CIContext(options: nil)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context,
                                  options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        
        if let features = detector?.features(in: ciImage) {
            var msg = ""
            if(features.count > 0) {
                msg = "\(features.count) QRCode detected, contents: \n"
                for feature in features as! [CIQRCodeFeature] {
                    msg = msg + feature.messageString!
                }
            } else {
                msg = "No QRCode detected"
            }
            
            let alertController = UIAlertController(title: "QRCode Detection", message: msg, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

