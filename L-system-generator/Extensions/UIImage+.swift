//
//  UIImage+.swift
//  L-system-generator
//
//  Created by André Schueda on 05/10/21.
//

import Foundation
import UIKit
import ImageIO
import MobileCoreServices
import UniformTypeIdentifiers
import Photos

extension UIImage {
    static func animatedGif(from images: [UIImage]) {
        let fileProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]  as CFDictionary
        let frameProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [(kCGImagePropertyGIFDelayTime as String): 0.05]] as CFDictionary
        
        let documentsDirectoryURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL: URL? = documentsDirectoryURL?.appendingPathComponent("animated.gif")
        
        if let url = fileURL as CFURL? {
            if let destination = CGImageDestinationCreateWithURL(url, UTType.gif.identifier as CFString, images.count, nil) {
                CGImageDestinationSetProperties(destination, fileProperties)
                for image in images {
                    if let cgImage = image.cgImage {
                        CGImageDestinationAddImage(destination, cgImage, frameProperties)
                    }
                }
                if !CGImageDestinationFinalize(destination) {
                    print("Failed to finalize the image destination")
                }
                PHPhotoLibrary.shared().performChanges ({
                    guard let fileURL = fileURL else { return }
                    PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
                }) { saved, error in
                    if saved {
                        print("Your image was successfully saved")
                    }
                }
            }
        }
    }
}
