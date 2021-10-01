//
//  GeneratorTextFieldView.swift
//  L-system-generator
//
//  Created by André Schueda on 30/09/21.
//

import UIKit

class GeneratorTextFieldView: UIView {
    let generatorContentView: GeneratorContentView
    let type: TextType
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = type == .axiom ? "Regra inicial" : "Regra para L"
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 22, weight: .bold)
        textField.delegate = self
        textField.tag = type == .axiom ? 0 : 1
        return textField
    }()
    
    init(frame: CGRect = .zero, type: TextType, generatorContentView: GeneratorContentView) {
        self.type = type
        self.generatorContentView = generatorContentView
        super.init(frame: frame)
        
        setupView()
        
        setupDescriptionLabel()
        setupTextField()
    }
    
    func setupView() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
    }
    
    func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
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

extension GeneratorTextFieldView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            generatorContentView.setAxiom(textField.text)
        case 1:
            generatorContentView.setRule(textField.text)
        default:
            print("shouldn't run")
        }
    }
}
