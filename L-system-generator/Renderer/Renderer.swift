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
    private lazy var actionToMethod: [RendererAction: () -> Void] = {
        [
            .line: {
                self.createLine(drawing: true)
            },
            .circle: {
                self.createCircle()
            },
            .lineLeftArc: {
                self.createLineAndArc(clockwise: true)
            },
            .lineRightArc: {
                self.createLineAndArc(clockwise: false)
            },
            .skip: {
                self.createLine(drawing: false)
            },
            .rotateClockwise: {
                guard let angle = self.angle else { return }
                self.currentAngle -= angle
            },
            .rotateAntiClockwise: {
                guard let angle = self.angle else { return }
                self.currentAngle += angle
            },
            .pushState: {
                let currentTurtleState = TurtleState(currentAngle: self.currentAngle, currentPosition: self.path.currentPoint, lineLength: self.lineLength)
                self.turtleStates.append(currentTurtleState)
            },
            .popState: {
                guard let savedState = self.turtleStates.popLast() else { return }
                self.path.move(to: savedState.currentPosition)
                self.currentAngle = savedState.currentAngle
                self.lineLength = savedState.lineLength
            }
        ]
    }()
    
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
    
    func generateLayer(byResult lSystemResult: LSystemResult, frame: CGRect, lineColor: UIColor, angle: CGFloat, lineWidth: CGFloat, padding: CGFloat) -> CAShapeLayer {
        path.move(to: CGPoint(x: frame.midX, y: 0))
        self.angle = angle
        
        for symbol in lSystemResult.string {
            guard let action = symbolToAction[symbol.description] else { continue }
            processAction(action)
        }
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath.resized(to: frame, padding: padding)
        layer.lineWidth = lineWidth
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = lineColor.cgColor
        
        
        return layer
    }
    
    private func processAction(_ action: RendererAction) {
        actionToMethod[action]?()
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
        path.move(to: path.currentPoint + CGPoint(x: lineLength * cos(currentAngle), y: lineLength * sin(currentAngle)))
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

enum RendererAction: Hashable {
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
