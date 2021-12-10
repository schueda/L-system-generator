//
//  GeneratorViewController.swift
//  L-system-generator
//
//  Created by André Schueda on 07/12/21.
//

import Foundation
import UIKit
import Angelo

class GeneratorViewModel {
    let artRepository = UserDefaultsArtsRepository.shared
    
    func saveArt(_ art: Art) {
        artRepository.saveArt(art)
    }
    
    func renderImageFrom(art: Art, with frame: CGRect, lineWidth: CGFloat, padding: CGFloat) -> CAShapeLayer {
        let iterations = art.iterations + 1
        art.axiom = Art.getLSystemRule(for: art.axiomString, to: "axioma")
        art.rule = Art.getLSystemRule(for: art.ruleString, to: "L")
        
        let system = LSystem(rules: [art.axiom!, art.rule!], transitions: [])
        let lSystemResult = system.produceOutput(input: "axioma", iterations: iterations)
        
        let renderer = Renderer()
        return renderer.generateLayer(byResult: lSystemResult, frame: frame, lineColor: art.lineColor ?? .appBlue, angle: CGFloat(art.angle) * CGFloat.pi/180, lineWidth: lineWidth, padding: padding)
    }
    
    func exportImageFrom(art: Art) {
        let exportView = UIView(frame: CGRect(x: 0, y: 0, width: 900, height: 1600))
        exportView.backgroundColor = art.backgroundColor
        exportView.layer.addSublayer(renderImageFrom(art: art, with: exportView.frame, lineWidth: 8, padding: 100))
        UIImageWriteToSavedPhotosAlbum(exportView.asImage(withScale: 3), nil, nil, nil)
    }
    
    func exportGifFrom(art: Art, completion: @escaping () -> ()) {
        let exportView = UIView(frame: CGRect(x: 0, y: 0, width: 900, height: 1600))
        exportView.backgroundColor = art.backgroundColor
        let frame = exportView.frame
        var framesDict: [Int: CAShapeLayer] = [:]
        let framesDictSemaphore = DispatchSemaphore(value: 1)
        let frameRenderingGroup = DispatchGroup()
        
        for angle in 0..<360 {
            DispatchQueue.global(qos: .userInitiated).async {
                frameRenderingGroup.enter()
                let copy = art.copy()
                copy.angle = angle
                let layer = self.renderImageFrom(art: copy, with: frame, lineWidth: 8, padding: 300)
                framesDictSemaphore.wait()
                framesDict[angle] = layer
                framesDictSemaphore.signal()
                frameRenderingGroup.leave()
            }
        }
        
        frameRenderingGroup.wait()
        DispatchQueue.main.async {
            var images: [UIImage] = []
            for angle in 0..<360 {
                exportView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                exportView.layer.addSublayer(framesDict[angle]!)
                images.append(exportView.asImage(withScale: 0.5))
            }
            UIImage.animatedGif(from: images)
            completion()
        }
        
    }
}
