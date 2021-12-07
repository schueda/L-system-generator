//
//  UserDefaultsArtsRepository.swift
//  L-system-generator
//
//  Created by André Schueda on 03/10/21.
//

import UIKit
import Angelo

class UserDefaultsArtsRepository: ArtsRepository {
    static let shared = UserDefaultsArtsRepository()
    
    private init() {}
    
    private static let artsKey = "ARTS"
    
    func saveArt(_ art: Art) {
        saveKey(from: art)
        saveCodable(art: art)
        saveImage(from: art)
        saveColors(from: art)
    }
    
    private func saveKey(from art: Art) {
        var keys = getKeys()
        if keys.firstIndex(of: art.id.uuidString) == nil{
            keys.append(art.id.uuidString)            
        }
        UserDefaults.standard.setValue(keys, forKey: Self.artsKey)
    }
    
    private func getKeys() -> [String] {
        let keys = UserDefaults.standard.array(forKey: Self.artsKey) as? [String]
        
        if let keys = keys {
            return keys
        }
        
        return []
    }
    
    private func saveCodable(art: Art) {
        do {
            let artData = try JSONEncoder().encode(art)
            UserDefaults.standard.setValue(artData, forKey: art.id.uuidString)
        } catch let err {
            print("failed saving art: \(err)")
        }
    }
    
    private func saveImage(from art: Art) {
        guard let image = art.image,
              var imageData = image.jpegData(compressionQuality: 1)
        else { return }
        
        if imageData.isEmpty {
            guard let pngdata = image.pngData() else { return }
            imageData = pngdata
        }
        
        do  {
            guard let imageURL = getImageURL(forKey: art.id.uuidString) else { return }
            try imageData.write(to: imageURL, options: .atomic)
        } catch let err {
            print("Saving image resulted in error: \(err)")
        }
    }
    
    private func getImageURL(forKey key: String) -> URL? {
        guard let imageURL = FileManager.default.urls(for: .documentDirectory,
                                                         in: FileManager.SearchPathDomainMask.userDomainMask).first
        else { return nil }
        return imageURL.appendingPathComponent("\(key)-image")
    }
    
    private func saveColors(from art: Art) {
        saveColor(art.backgroundColor, forKey: art.id.uuidString + "-backgroundColor")
        saveColor(art.lineColor, forKey: art.id.uuidString + "-lineColor")
    }
    
    private func saveColor(_ color: UIColor?, forKey key: String) {
        guard let color = color else { return }
        do {
            let colorData = try NSKeyedArchiver.archivedData(withRootObject: color,
                                                             requiringSecureCoding: false) as NSData?
            UserDefaults.standard.setValue(colorData, forKey: key)
        } catch let err {
            print("Error saving color: \(err)")
        }
    }
    
    func getAllArts() -> [Art] {
        var arts: [Art] = []
        let keys = getKeys()
        for key in keys {
            guard let art = getArt(forKey: key) else { continue }
            arts.append(art)
        }
        
        return arts
    }
    
    private func getArt(forKey key: String) -> Art? {
        guard let art = getEncodableArt(forKey: key) else { return nil }
        art.image = getArtImage(forKey: key)
        art.backgroundColor = getArtColor(forKey: key + "-backgroundColor")
        art.lineColor = getArtColor(forKey: key + "-lineColor")
        art.axiom = Art.getLSystemRule(for: art.axiomString, to: "axioma")
        art.rule = Art.getLSystemRule(for: art.ruleString, to: "L")
        
        return art
    }
    
    private func getEncodableArt(forKey key: String) -> Art? {
        do {
            guard let artData = UserDefaults.standard.data(forKey: key) else { return nil }
            let art = try JSONDecoder().decode(Art.self, from: artData)
            return art
            
        } catch let err {
            print("Error getting art: \(err)")
            return nil
        }
    }
    
    private func getArtImage(forKey key: String) -> UIImage? {
        guard let imageURL = getImageURL(forKey: key),
              let imageData = FileManager.default.contents(atPath: imageURL.path)
        else { return nil }
        
        return UIImage(data: imageData)
    }
    
    private func getArtColor(forKey key: String) -> UIColor? {
        do {
            guard let colorData = UserDefaults.standard.data(forKey: key) else { return nil }
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
            return color
        } catch let err {
            print("Error getting color: \(err)")
            return nil
        }
    }
    
    func deleteArt(_ art: Art) {
        deleteKey(from: art)
        deleteCodable(art: art)
        deleteImage(from: art)
        deleteColors(from: art)
    }
    
    private func deleteKey(from art: Art) {
        var keys = getKeys()
        guard let keyIndex = keys.firstIndex(of: art.id.uuidString) else { return }
        keys.remove(at: keyIndex)
        UserDefaults.standard.setValue(keys, forKey: Self.artsKey)
    }
    
    private func deleteCodable(art: Art) {
        UserDefaults.standard.removeObject(forKey: art.id.uuidString)
    }
    
    private func deleteImage(from art: Art) {
        guard let imageURL = getImageURL(forKey: art.id.uuidString) else { return }
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch let err {
            print("Error deleting image: \(err)")
        }
    }
    
    private func deleteColors(from art: Art) {
        deleteColor(forKey: "\(art.id.uuidString)-backgroundColor")
        deleteColor(forKey: "\(art.id.uuidString)-lineColor")
    }
    
    private func deleteColor(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
