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
    
    lazy var randomButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "dice"), for: .normal)
        button.imageView?.tintColor = .label
        button.addTarget(self, action: #selector(clickedRandom), for: .touchUpInside)
        return button
    }()
    
    @objc func clickedRandom() {
        let randomRule = RuleGenerator.shared.getRamdomRule()
        textField.text = randomRule
        
        changedTextField(sender: textField)
    }
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 18, weight: .bold)
        textField.addTarget(self, action: #selector(changedTextField), for: .editingChanged)
        textField.tag = type == .axiom ? 0 : 1
        return textField
    }()
    
    @objc func changedTextField(sender: UITextField) {
        if generatorContentView.iterations > 4 {
            generatorContentView.stepperView.setIterations(4)
            generatorContentView.iterations = 4
        }
        
        switch type {
        case .axiom:
            generatorContentView.setAxiom(sender.text)
        case .rule:
            generatorContentView.setRule(sender.text)
        }
    }
    
    init(frame: CGRect = .zero, type: TextType, generatorContentView: GeneratorContentView) {
        self.type = type
        self.generatorContentView = generatorContentView
        super.init(frame: frame)
        
        setupView()
        
        setupDescriptionLabel()
        setupRandomButton()
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
    
    func setupRandomButton() {
        addSubview(randomButton)
        randomButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    func setupTextField() {
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalTo(randomButton.snp.leading).offset(-8)
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
