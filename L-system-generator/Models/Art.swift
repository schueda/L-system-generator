//
//  Art.swift
//  L-system-generator
//
//  Created by André Schueda on 03/10/21.
//

import UIKit
import Angelo

class Art: Codable, CustomDebugStringConvertible {
    var debugDescription: String {
        "axiom: \(axiomString)  |  rule: \(ruleString)  |  iterations: \(iterations)  |  angle: \(angle)"
    }
    
    var id: UUID
    
    var axiomString: String
    var ruleString: String
    var iterations: Int
    var angle: Int
    var backgroundColor: UIColor?
    var lineColor: UIColor?
    
    var axiom: LSystemRule?
    var rule: LSystemRule?
    
    var image: UIImage?
    
    init(axiomString: String, ruleString: String, iterations: Int,
         angle: Int, backgroundColor: UIColor,
         lineColor: UIColor, image: UIImage? = nil, id: UUID = UUID()) {
        self.id = id
        
        self.axiomString = axiomString
        self.ruleString = ruleString
        self.iterations = iterations
        self.angle = angle
        self.backgroundColor = backgroundColor
        self.lineColor = lineColor
        
        self.image = image
    }
    
    convenience init() {
        let colors = UIColor.getRandomPair()
        self.init(axiomString: RuleGenerator.shared.getRandomRule(), ruleString: RuleGenerator.shared.getRandomRule(), iterations: 3, angle: Int.random(in: 0...180), backgroundColor: colors.background, lineColor: colors.line)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case axiomString
        case ruleString
        case iterations
        case angle
    }
    
    func copy() -> Art {
        return Art(axiomString: axiomString, ruleString: ruleString, iterations: iterations, angle: angle, backgroundColor: backgroundColor ?? .appWhite, lineColor: lineColor ?? .appBlue)
    }
    
    static func getLSystemRule(for string: String, to input: String) -> LSystemRule {
        var charArray: [String] = []
        string.forEach({ charArray.append($0.description) })
        return LSystemRule(input: input, outputs: charArray)
    }
}
