//
//  File.swift
//  L-system-generator
//
//  Created by André Schueda on 01/10/21.
//

import Foundation

class RuleGenerator {
    static let shared = RuleGenerator()
    
    private init() {}
    
    func getRamdomRule() -> String {
        let chars = ["L", "L", "L", "L", "L", "L", "+", "+",  "+", "-", "-", "-", "C", "E", "D"]
        var rule = "L"
        
        let ruleLength = Int.random(in: 3...5)
        
        for _ in 0..<ruleLength {
            rule += chars.shuffled().first!
        }
        
        return rule
    }
}
