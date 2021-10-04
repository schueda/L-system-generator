//
//  HomeButtonView.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit

class HomeButtonView: UIView {
    let type: ButtonType
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
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
        setupTitleLabel()
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
