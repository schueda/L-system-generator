//
//  UIView+.swift
//  L-system-generator
//
//  Created by André Schueda on 03/10/21.
//

import UIKit

extension UIView {
    func asImage(withScale scale: CGFloat = 1) -> UIImage {
        self.contentScaleFactor = scale
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: bounds.size, format: format)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func addTapGesture(tapNumber: Int, target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}
