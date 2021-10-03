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
    
    var angle: CGFloat?
    var currentAngle: CGFloat = -CGFloat.pi/2
    
    var lineLength: CGFloat = 10
    
    var turtleStates: [TurtleState] = []
    
    let symbolToAction: [String: RendererAction] = [
        "L": .line,
        "C": .circle,
        "E": .lineLeftArc,
        "D": .lineRightArc,
        "S": .skip,
        "+": .rotateAntiClockwise,
        "-": .rotateClockwise,
        "[": .pushState,
        "]": .popState
    ]
    
    func generateLayer(byResult lSystemResult: LSystemResult, frame: CGRect, lineColor: UIColor, angle: CGFloat) -> CAShapeLayer {
        path.move(to: CGPoint(x: frame.midX, y: 0))
        self.angle = angle
        
        for symbol in lSystemResult.string {
            guard let action = symbolToAction[symbol.description] else { continue }
            processAction(action)
        }
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath.resized(to: frame)
        layer.lineWidth = 3
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = lineColor.cgColor
        
        
        return layer
    }
    
    private func processAction(_ action: RendererAction) {
        switch action {
        case .line:
            createLine(drawing: true)
        case .circle:
            createCircle()
        case .lineLeftArc:
            createLineAndArc(clockwise: true)
        case .lineRightArc:
            createLineAndArc(clockwise: false)
        case .skip:
            createLine(drawing: false)
        case .rotateAntiClockwise:
            guard let angle = angle else { return }
            currentAngle += angle
        case .rotateClockwise:
            guard let angle = angle else { return }
            currentAngle -= angle
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
    
    private func createCircle() {
        path.addArc(
            withCenter: path.currentPoint + CGPoint(x: lineLength/2 * cos(currentAngle), y: lineLength/2 * sin(currentAngle)),
            radius: lineLength/2,
            startAngle: currentAngle + CGFloat.pi,
            endAngle: currentAngle + 3 * CGFloat.pi,
            clockwise: true
        )
    }
    
    private func createLineAndArc(clockwise: Bool) {
        let halfWay = path.currentPoint + CGPoint(x: lineLength/2 * cos(currentAngle), y: lineLength/2 * sin(currentAngle))
        path.addLine(to: halfWay)
        
        path.addArc(withCenter: path.currentPoint + CGPoint(x: lineLength/4 * cos(currentAngle), y: lineLength/4 * sin(currentAngle)),
                    radius: lineLength/4,
                    startAngle: currentAngle + CGFloat.pi,
                    endAngle: currentAngle,
                    clockwise: clockwise)
    }
    
}

struct TurtleState {
    let currentAngle: CGFloat
    let currentPosition: CGPoint
    let lineLength: CGFloat
}

enum RendererAction {
    case line
    case circle
    case lineLeftArc
    case lineRightArc
    case skip
    case rotateAntiClockwise
    case rotateClockwise
    case pushState
    case popState
}
