//
//  GeneratorColorsView.swift
//  L-system-generator
//
//  Created by André Schueda on 01/10/21.
//

import UIKit

class GeneratorColorsView: UIView {
    let colors: [UIColor] = [.appRed, .appYellow, .appGreen, .appBlue, .appPurple, .appWhite]
    
    lazy var backgroundLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "Cor do fundo"
        return label
    }()
    
    lazy var backgroundButtonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var backgroundButtons: [UIButton] = {
        var backgroundButtons: [UIButton] = []
        for color in colors {
            backgroundButtons.append(generateColorButton(color: color))
        }
        return backgroundButtons
    }()
    
    func generateColorButton(color: UIColor) -> UIButton {
        let button = UIButton()
        button.backgroundColor = color
        button.addTarget(self, action: #selector(backgroundButtonClicked), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.borderWidth = 1
        return button
    }
    
    @objc func backgroundButtonClicked(sender: UIButton) {
        print(sender.backgroundColor ?? "")
    }
    
    lazy var lineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "Cor da linha"
        return label
    }()
    
    lazy var lineButtonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var lineButtons: [UIButton] = {
        var lineButtons: [UIButton] = []
        for color in colors {
            lineButtons.append(generateColorButton(color: color))
        }
        return lineButtons
    }()
    
    @objc func lineButtonClicked(sender: UIButton) {
        print(sender.backgroundColor ?? "")
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setupView()
        
        setupBackgroundLabel()
        setupBackgroundButtonsStackView()
        
        setupLineLabel()
        setupLineButtonsStackView()
    }
    
    func setupView() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
    }
    
    func setupBackgroundLabel() {
        addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(8)
        }
    }
    
    func setupBackgroundButtonsStackView() {
        addSubview(backgroundButtonsStackView)
        backgroundButtonsStackView.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom).offset(1)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(40)
        }
        
        backgroundButtons.forEach { backgroundButtonsStackView.addArrangedSubview($0) }
    }
    
    func setupLineLabel() {
        addSubview(lineLabel)
        lineLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundButtonsStackView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
        }
    }
    
    func setupLineButtonsStackView() {
        addSubview(lineButtonsStackView)
        lineButtonsStackView.snp.makeConstraints { make in
            make.top.equalTo(lineLabel.snp.bottom).offset(1)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        lineButtons.forEach { lineButtonsStackView.addArrangedSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
