//
//  Art.swift
//  L-system-generator
//
//  Created by André Schueda on 03/10/21.
//

import UIKit

class Art: Codable {
    var id: UUID
    
    var axiom: String
    var rule: String
    var iterations: Int
    var angle: Int
    var backgroundColor: UIColor?
    var lineColor: UIColor?
    
    var image: UIImage?
    
    init(axiom: String, rule: String, iterations: Int,
         angle: Int, backgroundColor: UIColor,
         lineColor: UIColor, image: UIImage? = nil, id: UUID = UUID()) {
        self.id = id
        
        self.axiom = axiom
        self.rule = rule
        self.iterations = iterations
        self.angle = angle
        self.backgroundColor = backgroundColor
        self.lineColor = lineColor
        
        self.image = image
    }
    
    convenience init() {
        self.init(axiom: RuleGenerator.shared.getRamdomRule(), rule: RuleGenerator.shared.getRamdomRule(), iterations: 0,
                  angle: 90, backgroundColor: .appWhite,
                  lineColor: .appBlue)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case axiom
        case rule
        case iterations
        case angle
    }
    
}
