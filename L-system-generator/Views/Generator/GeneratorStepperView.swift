//
//  GeneratorStepperView.swift
//  L-system-generator
//
//  Created by André Schueda on 01/10/21.
//

import UIKit

class GeneratorStepperView: UIView {
    var value: Int = 0
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "Iterações"
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "\(value)"
        return label
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        button.imageView?.tintColor = .systemGray6
        return button
    }()
    
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        button.imageView?.tintColor = .systemGray6
        return button
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setupView()
        
        setupDescriptionLabel()
        setupValueView()
        setupPlusButton()
        setupMinusButton()
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
        }
    }
    
    func setupValueView() {
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.centerX.equalTo(descriptionLabel)
        }
    }
    
    func setupPlusButton() {
        addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(40)
        }
    }
    
    func setupMinusButton() {
        addSubview(minusButton)
        minusButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalTo(plusButton.snp.leading).offset(-6)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(40)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
