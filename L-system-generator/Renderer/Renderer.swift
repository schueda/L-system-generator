//
//  Renderer.swift
//  L-system-generator
//
//  Created by André Schueda on 29/09/21.
//

import Foundation
import QuartzCore
import Angelo
import UIKit

class Renderer {
    private let path = UIBezierPath()
    let rotationAngle: CGFloat
    var currentAngle: CGFloat = -CGFloat.pi/2
    
    var lineLength: CGFloat = 10
    
    var turtleStates: [TurtleState] = []
    
    let symbolToAction: [String: RendererAction] = [
        "L": .line,
        "S": .skip,
        "+": .rotateAntiClockwise,
        "-": .rotateClockwise,
        "[": .pushState,
        "]": .popState
    ]
    
    init(rotationAngle: CGFloat = 90) {
        self.rotationAngle = rotationAngle
    }
    
    func generateLayer(by lSystemResult: LSystemResult, frame: CGRect) -> CAShapeLayer {
        path.move(to: CGPoint(x: frame.midX, y: 0))
        
        for symbol in lSystemResult.string {
            guard let action = symbolToAction[symbol.description] else { continue }
            processAction(action)
        }
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath.resized(to: frame)
        layer.lineWidth = 3
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.red.cgColor
        
        return layer
    }
    
    private func processAction(_ action: RendererAction) {
        switch action {
        case .line:
            createLine(drawing: true)
        case .skip:
            createLine(drawing: false)
        case .rotateAntiClockwise:
            currentAngle += rotationAngle
        case .rotateClockwise:
            currentAngle -= rotationAngle
        case .pushState:
            let currentTurtleState = TurtleState(currentAngle: currentAngle, currentPosition: path.currentPoint, lineLength: lineLength)
            turtleStates.append(currentTurtleState)
        case .popState:
            guard let savedState = turtleStates.popLast() else { return }
            path.move(to: savedState.currentPosition)
            currentAngle = savedState.currentAngle
            lineLength = savedState.lineLength
            
        }
    }
    
    private func createLine(drawing: Bool) {
        let finalPoint = path.currentPoint + CGPoint(x: lineLength * cos(currentAngle), y: lineLength * sin(currentAngle))
        if drawing {
            path.addLine(to: finalPoint)
        } else {
            path.move(to: finalPoint)
        }
    }
    
}

struct TurtleState {
    let currentAngle: CGFloat
    let currentPosition: CGPoint
    let lineLength: CGFloat
}

enum RendererAction {
    case line
    case skip
    case rotateAntiClockwise
    case rotateClockwise
    case pushState
    case popState
}
