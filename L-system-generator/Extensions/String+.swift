//
//  String+.swift
//  L-system-generator
//
//  Created by André Schueda on 03/10/21.
//

import Foundation

extension String {
    func asArray() -> [String] {
        var charArray: [String] = []
        self.forEach({ charArray.append($0.description) })
        return charArray
    }
}
