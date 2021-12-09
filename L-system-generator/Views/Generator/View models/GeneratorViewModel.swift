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
    
    func renderImageFrom(art: Art, with frame: CGRect, stepperView: GeneratorStepperView, lineWidth: CGFloat, padding: CGFloat) -> CAShapeLayer {
        var iterations = art.iterations + 1
        art.axiom = Art.getLSystemRule(for: art.axiomString, to: "axioma")
        art.rule = Art.getLSystemRule(for: art.ruleString, to: "L")
        
        let system = LSystem(rules: [art.axiom!, art.rule!], transitions: [])
        var lSystemResult = system.produceOutput(input: "axioma", iterations: iterations)
        if system.produceOutput(input: "axioma", iterations: iterations+1).outputElements.count > 2500 {
            stepperView.plusButton.isEnabled = false
        }
    
        while lSystemResult.outputElements.count > 2500 {
            iterations -= 1
            lSystemResult = system.produceOutput(input: "axioma", iterations: iterations)
            stepperView.plusButton.isEnabled = false
        }
        
        let renderer = Renderer()
        return renderer.generateLayer(byResult: lSystemResult, frame: frame, lineColor: art.lineColor ?? .appBlue, angle: CGFloat(art.angle) * CGFloat.pi/180, lineWidth: lineWidth, padding: padding)
    }
    
    func exportImageFrom(art: Art, stepperView: GeneratorStepperView) {
        let exportView = UIView(frame: CGRect(x: 0, y: 0, width: 900, height: 1600))
        exportView.backgroundColor = art.backgroundColor
        exportView.layer.addSublayer(renderImageFrom(art: art, with: exportView.frame, stepperView: stepperView, lineWidth: 8, padding: 100))
        UIImageWriteToSavedPhotosAlbum(exportView.asImage(withScale: 3), nil, nil, nil)
    }
    
    func exportGifFrom(art: Art, stepperView: GeneratorStepperView, completion: () -> ()) {
        var images: [UIImage] = []
        let exportView = UIView(frame: CGRect(x: 0, y: 0, width: 900, height: 1600))
        exportView.backgroundColor = art.backgroundColor
        
        for angle in 0...360 {
            exportView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            art.angle = angle
            exportView.layer.addSublayer(renderImageFrom(art: art, with: exportView.frame, stepperView: stepperView, lineWidth: 8, padding: 300))
            images.append(exportView.asImage(withScale: 0.5))
        }
        UIImage.animatedGif(from: images)
        
        completion()
    }
}
