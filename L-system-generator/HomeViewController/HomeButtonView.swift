//
//  HomeButtonView.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit

class HomeButtonView: UIView {
    let type: ButtonType
    
    lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray
        imageView.image = type == .gallery ? UIImage(named:"GalleryButton") : UIImage(named:"GeneratorButton")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = type == .gallery ? "Galeria" : "Gerador"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    init(frame: CGRect = .zero, type: ButtonType) {
        self.type = type
        super.init(frame: frame)
        
        layer.cornerRadius = 20
        clipsToBounds = true
        
        setupBackgroundImage()
        setupTitleLabel()
    }
    
    func setupBackgroundImage() {
        addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(220)
        }
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum ButtonType {
        case gallery
        case generator
    }
}
