//
//  ArtsRepositoryProtocol.swift
//  L-system-generator
//
//  Created by André Schueda on 03/10/21.
//

import Foundation

protocol ArtsRepository {
    func saveArt(_ art: Art)
    func getAllArts() -> [Art]
    func deleteArt(_ art: Art)
}
