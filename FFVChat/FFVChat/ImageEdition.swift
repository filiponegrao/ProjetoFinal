//
//  ImageEdition.swift
//  FFVChat
//
//  Created by Filipo Negrao on 24/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class ImageEdition
{
    
    class func compressImage(image: UIImage) -> UIImage
    {
        UIGraphicsBeginImageContext(image.size)
//        let context = UIGraphicsGetCurrentContext()
        
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    class func blurImage(image: UIImage) -> UIImage
    {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        blur.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        blur.alpha = 1
        
        UIGraphicsBeginImageContext(image.size)
        
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        blur.drawRect(CGRectMake(0, 0, image.size.width, image.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
}

extension UIImage {
    var highestQualityJPEGNSData:NSData { return UIImageJPEGRepresentation(self, 1.0)! }
    var highQualityJPEGNSData:NSData    { return UIImageJPEGRepresentation(self, 0.75)!}
    var mediumQualityJPEGNSData:NSData  { return UIImageJPEGRepresentation(self, 0.5)! }
    var lowQualityJPEGNSData:NSData     { return UIImageJPEGRepresentation(self, 0.25)!}
    var lowestQualityJPEGNSData:NSData  { return UIImageJPEGRepresentation(self, 0.0)! }
}

