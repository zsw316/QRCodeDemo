//
//  GenerateQRCodeViewController.swift
//  QRCodeDemo
//
//  Created by Ashley Han on 16/09/17.
//  Copyright © 2017 simpletask. All rights reserved.
//

import UIKit
import Photos

class GenerateQRCodeViewController: UIViewController {

    var inputTextView: UITextView!
    var generateButton: UIButton!
    var qrCodeContainer: UIView!
    var qrCodeImageView: UIImageView!
    var qrCodeQenerated: Bool = false
    
    var saveQRCodeToAlbum: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .init(rawValue: 0)
        view.backgroundColor = .white
        
        inputTextView = UITextView(frame: CGRect(x: 8, y: 10, width: view.frame.width - 16, height: 50))
        inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        inputTextView.layer.borderWidth = 1.0 / UIScreen.main.scale
        inputTextView.font = UIFont.systemFont(ofSize: 12)
        inputTextView.backgroundColor = .white
        inputTextView.isEditable = true
        view.addSubview(inputTextView)
        
        generateButton = UIButton(frame: CGRect(x: 8, y: 68, width: view.frame.width - 16, height: 30))
        generateButton.setTitle("Generate", for: .normal)
        generateButton.backgroundColor = .blue
        generateButton.addTarget(self, action: #selector(GenerateQRCodeViewController.didTapGenerateButton(button:)), for: .touchUpInside)
        view.addSubview(generateButton)
        
        qrCodeContainer = UIView(frame: CGRect(x: (view.frame.width-270) / 2, y: 118, width: 270, height: 270))
        qrCodeContainer.backgroundColor = .white
        qrCodeContainer.layer.cornerRadius = 6.0
        qrCodeContainer.layer.borderColor = UIColor.lightGray.cgColor
        qrCodeContainer.layer.borderWidth = 1.0 / UIScreen.main.scale
        qrCodeContainer.layer.masksToBounds = true
        view.addSubview(qrCodeContainer)
        
        qrCodeImageView = UIImageView(frame: CGRect(x: (qrCodeContainer.bounds.width-240) / 2, y: (qrCodeContainer.bounds.height-240) / 2, width: 240, height: 240))
        
        qrCodeContainer.addSubview(qrCodeImageView);
        
        saveQRCodeToAlbum = UIButton(type: .system)
        saveQRCodeToAlbum.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        saveQRCodeToAlbum.setTitle("Save", for: .normal)
        saveQRCodeToAlbum.isEnabled = false
        saveQRCodeToAlbum.addTarget(self, action: #selector(GenerateQRCodeViewController.didTapSaveButton(button:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveQRCodeToAlbum)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapGenerateButton(button: UIButton) -> Void {
        
        if(inputTextView.text.characters.count == 0)
        {
            return;
        }
        
        if let img = QRCodeHelper.createQRFromString(inputTextView.text, size: CGSize(width: 240, height: 240))
        {
            qrCodeImageView.image = UIImage(ciImage: img, scale: 1.0, orientation: UIImageOrientation.up)
            qrCodeQenerated = true
        }
        
        inputTextView.resignFirstResponder()
    }
    
    func didTapSaveButton(button: UIButton) -> Void {
        if(!qrCodeQenerated)
        {
            return
        }
        
        guard let img = saveQRCodeToImage() else {
            return
        }
        
        let activityView = DejalActivityView.init(for: self.view, withLabel: "Saving...", width: 50)
        PHPhotoLibrary.shared().savePhoto(image: img, albumName: "QRCodeDemo") { (asset: PHAsset?) in
            activityView?.removeFromSuperview()
            var msg = ""
            if asset != nil {
                msg = "Save image success"
            } else {
                msg = "Save image failed"
            }
            
            let alertController = UIAlertController.init(title: "Prompt", message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func saveQRCodeToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(qrCodeContainer.bounds.size, qrCodeContainer.isOpaque, 0.0)
        qrCodeContainer.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
