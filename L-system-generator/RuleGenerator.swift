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
        let chars = ["L", "L", "L", "L", "L", "L", "+", "+", "-", "-", "C", "E", "D"]
        var rule = "L"
        
        let ruleLength = Int.random(in: 3...5)
        
        for _ in 0..<ruleLength {
            rule += chars.shuffled().first!
        }
        
        if ruleLength == 4 && Int.random(in: 1...10) > 3 {
            rule.insert("[", at: rule.index(rule.startIndex, offsetBy: 1))
            rule.insert("+", at: rule.index(rule.startIndex, offsetBy: 2))
            rule.insert("]", at: rule.index(rule.startIndex, offsetBy: 5))
            rule.insert("L", at: rule.index(rule.startIndex, offsetBy: 6))
        }
        
        return rule
    }
}
