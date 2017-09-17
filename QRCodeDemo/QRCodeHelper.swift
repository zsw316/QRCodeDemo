//
//  QRCodeHelper.swift
//  QRCodeDemo
//
//  Created by Ashley Han on 16/09/17.
//  Copyright © 2017 simpletask. All rights reserved.
//

import UIKit
import CoreImage

class QRCodeHelper: NSObject {

    static func createQRFromString(_ str: String, size: CGSize) -> CIImage? {
        let stringData = str.data(using: String.Encoding.utf8)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(stringData, forKey: "inputMessage")
        
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let outputImage = filter?.outputImage else {
            return nil
        }
        
        let scaleX = size.width / outputImage.extent.size.width
        let scaleY = size.height / outputImage.extent.size.height
        
        return outputImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
    }
}
