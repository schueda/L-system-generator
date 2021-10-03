//
//  GalleryRepositoryProtocol.swift
//  L-system-generator
//
//  Created by André Schueda on 03/10/21.
//

import Foundation

protocol GalleryRepository {
    func saveArt(_ art: Art)
    func getAllArts() -> [Art]
    func updateArt()
    func deleteArt()
}
