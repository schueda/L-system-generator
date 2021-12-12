//
//  GeneratorColorsView.swift
//  L-system-generator
//
//  Created by André Schueda on 01/10/21.
//

import UIKit

class GeneratorColorsView: UIView {
    let parent: GeneratorViewController
    
    let colors: [UIColor] = [.appRed, .appYellow, .appGreen, .appBlue, .appPurple, .appWhite]
    
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
            let button = generateColorButton(color: color)
            button.addTarget(self, action: #selector(lineButtonClicked), for: .touchUpInside)
            lineButtons.append(button)
        }
        return lineButtons
    }()
    
    @objc func lineButtonClicked(sender: UIButton) {
        parent.setLSystemLineColor(sender.backgroundColor)
        DefaultAnalyticsService.shared.log(event: .changedLineColor)
    }
    
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
            let button = generateColorButton(color: color)
            button.addTarget(self, action: #selector(backgroundButtonClicked), for: .touchUpInside)
            backgroundButtons.append(button)
        }
        return backgroundButtons
    }()
    
    func generateColorButton(color: UIColor) -> UIButton {
        let button = UIButton()
        button.backgroundColor = color
        button.layer.cornerRadius = 10
        return button
    }
    
    @objc func backgroundButtonClicked(sender: UIButton) {
        parent.setLSystemBackgroundColor(sender.backgroundColor)
        DefaultAnalyticsService.shared.log(event: .changedBackgroundColor)
    }

    init(frame: CGRect = .zero, parent: GeneratorViewController) {
        self.parent = parent
        super.init(frame: frame)
        
        setupView()
        
        setupLineLabel()
        setupLineButtonsStackView()
        
        setupBackgroundLabel()
        setupBackgroundButtonsStackView()
        
    }
    
    func setupView() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
    }
    
    func setupLineLabel() {
        addSubview(lineLabel)
        lineLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
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
        }
        
        lineButtons.forEach { lineButtonsStackView.addArrangedSubview($0) }
    }
    
    func setupBackgroundLabel() {
        addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalTo(lineButtonsStackView.snp.bottom).offset(8)
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
            make.bottom.equalToSuperview().offset(-8)
        }
        
        backgroundButtons.forEach { backgroundButtonsStackView.addArrangedSubview($0) }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
