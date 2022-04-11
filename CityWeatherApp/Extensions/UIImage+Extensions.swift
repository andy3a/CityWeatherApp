//
//  UIImage+Extensions.swift
//  CityWeatherApp
//
//  Created by Andrew_Alekseyuk on 8.04.22.
//

import UIKit

extension UIImage {
    func makeImageDarker() -> UIImage {
        let inputImage = CIImage(image: self)
        guard let filter = CIFilter(name: "CIWhitePointAdjust") else {return UIImage()}
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(CIColor.gray, forKey: kCIInputColorKey)
        
        guard let filteredImage = filter.outputImage else { return UIImage()}
        let context = CIContext(options: nil)
        let outputImage = UIImage(cgImage: context.createCGImage(filteredImage, from: filteredImage.extent)!)
        return outputImage
    }
}
