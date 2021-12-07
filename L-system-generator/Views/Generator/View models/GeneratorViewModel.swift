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
    
    func renderImageFrom(_ art: Art, with frame: CGRect, stepperView: GeneratorStepperView) -> CAShapeLayer {
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
        return renderer.generateLayer(byResult: lSystemResult, frame: frame, lineColor: art.lineColor ?? .appBlue, angle: CGFloat(art.angle) * CGFloat.pi/180)
    }
}
