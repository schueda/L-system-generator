//
//  HomeButtonView.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit
import SnapKit

class HomeButtonView: UIView {
    let type: ButtonType
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = type == .gallery
            ? UIImage(systemName: "photo.on.rectangle.angled", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular))
            : UIImage(systemName: "wand.and.stars", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .bold))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = type == .gallery ? "Galeria" : "Gerador"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .appWhite
        return label
    }()
    
    init(frame: CGRect = .zero, type: ButtonType) {
        self.type = type
        super.init(frame: frame)
        
       
        setupView()
        setupBluredBackground()
        
        setupStack()
        
        [
            iconImageView,
            titleLabel
        ].forEach { stack.addArrangedSubview($0) }
//        setupIconImageView()
    }
    
    func setupView() {
        isUserInteractionEnabled = false
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    func setupBluredBackground() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let bluredView = UIVisualEffectView(effect: blurEffect)
        addSubview(bluredView)
        bluredView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupStack() {
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.bottom.equalToSuperview().offset(-22)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupIconImageView() {
        iconImageView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(type == .gallery ? 3 : 60).priority(.low)
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
