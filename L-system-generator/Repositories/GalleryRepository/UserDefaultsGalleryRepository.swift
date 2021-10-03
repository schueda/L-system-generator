//
//  UserDefaultsGalleryRepository.swift
//  L-system-generator
//
//  Created by André Schueda on 03/10/21.
//

import UIKit

class UserDefaultsGalleryRepository: GalleryRepository {
    private static let artsKey = "ARTS"
    private static let imagesKey = "IMAGES"
    
    func saveArt(_ art: Art) {
        saveKey(art.id.uuidString)
        saveObject(art)
        saveImage(art.image)
        
    }
    
    func saveKey(_ key: String) {
        var keys = getKeys()
        keys.append(key)
        UserDefaults.standard.setValue(keys, forKey: Self.artsKey)
    }
    
    func getKeys() -> [String] {
        let keys = UserDefaults.standard.array(forKey: Self.artsKey) as? [String]
        
        if let keys = keys {
            return keys
        }
        
        return []
    }
    
    func saveObject(_ art: Art) {
        do {
            let artData = try JSONEncoder().encode(art)
            UserDefaults.standard.setValue(artData, forKey: art.id.uuidString)
        } catch {
            print("failed saving art")
        }
    }
    
    func saveImage(_ image: UIImage?) {
        guard let image = image,
              var imageData = image.jpegData(compressionQuality: 1)
        else { return }
        
        if imageData.isEmpty {
            guard let pngdata = image.pngData() else { return }
            imageData = pngdata
        }
        
        do  {
            guard let imagePath = self.getImagePath(forKey: key) else { return }
            try image.write(to: imagePath, options: .atomic)
        } catch let err {
            print("Saving image resulted in error: ", err)
        }
    }
    
    
    func getAllArts() -> [Art] {
        return []
    }
    
    func updateArt() {
        
    }
    
    func deleteArt() {
        
    }
    
}
