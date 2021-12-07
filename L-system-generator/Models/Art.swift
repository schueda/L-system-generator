//
//  Art.swift
//  L-system-generator
//
//  Created by André Schueda on 03/10/21.
//

import UIKit
import Angelo

class Art: Codable {
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
        self.init(axiomString: RuleGenerator.shared.getRamdomRule(), ruleString: RuleGenerator.shared.getRamdomRule(), iterations: 3, angle: 90, backgroundColor: .appWhite, lineColor: .appBlue)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case axiomString
        case ruleString
        case iterations
        case angle
    }
    
    static func getLSystemRule(for string: String, to input: String) -> LSystemRule {
        var charArray: [String] = []
        string.forEach({ charArray.append($0.description) })
        return LSystemRule(input: input, outputs: charArray)
    }
    
}
