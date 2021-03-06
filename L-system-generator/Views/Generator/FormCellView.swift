//
//  FormCellView.swift
//  L-system-generator
//
//  Created by André Schueda on 30/09/21.
//

import UIKit

class FormCellView: UIView {
    let type: TextType
    
    lazy var descriptionText: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = type == .axiom ? "Regra inicial" : "Regra para L"
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 22, weight: .bold)
        return textField
    }()
    
    init(frame: CGRect = .zero, type: TextType) {
        self.type = type
        super.init(frame: frame)
        
        setupView()
        setupDescriptionText()
        setupTextField()
    }
    
    func setupView() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
    }
    
    func setupDescriptionText() {
        addSubview(descriptionText)
        descriptionText.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    func setupTextField() {
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum TextType {
        case axiom
        case rule
    }
}
