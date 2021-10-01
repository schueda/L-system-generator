//
//  CGPath+.swift
//  L-system-generator
//
//  Created by André Schueda on 29/09/21.
//

import Foundation
import UIKit

extension CGPath {
    func resized(to rect: CGRect) -> CGPath {
        let boundingBox = self.boundingBox
        let boundingBoxAspectRatio = boundingBox.width / boundingBox.height
        let viewAspectRatio = rect.width / rect.height
        let scaleFactor = boundingBoxAspectRatio > viewAspectRatio ?
            (rect.width - 8) / boundingBox.width :
            (rect.height - 8) / boundingBox.height

        let scaledSize = boundingBox.size.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        let centerOffset = CGSize(
            width: (rect.width - scaledSize.width) / (scaleFactor * 2),
            height: (rect.height - scaledSize.height) / (scaleFactor * 2)
        )

        var transform = CGAffineTransform.identity
            .scaledBy(x: scaleFactor, y: scaleFactor)
            .translatedBy(x: -boundingBox.minX + centerOffset.width, y: -boundingBox.minY + centerOffset.height)

        return copy(using: &transform)!
    }
}
