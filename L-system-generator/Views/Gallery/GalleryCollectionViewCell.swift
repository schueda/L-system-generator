//
//  GalleryCollectionViewCell.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray2
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
