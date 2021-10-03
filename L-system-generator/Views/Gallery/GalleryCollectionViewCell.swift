//
//  GalleryCollectionViewCell.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    var art: Art?
    
    lazy var artImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray2
        layer.cornerRadius = 10
        clipsToBounds = true
        
        setupArtImageView()
    }
    
    private func setupArtImageView() {
        addSubview(artImageView)
        artImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
    
    func setArt(_ art: Art) {
        self.art = art
        artImageView.image = art.image
        backgroundColor = art.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
