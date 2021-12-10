//
//  ExportButtonView.swift
//  L-system-generator
//
//  Created by André Schueda on 09/12/21.
//

import UIKit

class ExportButtonView: UIView {
    let type: ButtonType
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = type == .image ? UIImage(systemName: "photo.on.rectangle") : UIImage(systemName: "play.circle")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .label
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = type == .image ? "Exportar PNG" : "Exportar GIF"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(frame: CGRect = .zero, type: ButtonType) {
        self.type = type
        super.init(frame: frame)
        
        setupView()
        setupImageView()
        setupLabel()
    }
    
    private func setupView() {
        isUserInteractionEnabled = false
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
    }
    
    private func setupLabel() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum ButtonType {
        case image
        case gif
    }
}
