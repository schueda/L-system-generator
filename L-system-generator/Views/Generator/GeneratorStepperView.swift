//
//  GeneratorStepperView.swift
//  L-system-generator
//
//  Created by André Schueda on 01/10/21.
//

import UIKit

class GeneratorStepperView: UIView {
    let generatorContentView: GeneratorContentView

    var maximum: Int = 10
    var iterations: Int = 0
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "Iterações"
        return label
    }()
    
    lazy var iterationsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "\(iterations)"
        return label
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        button.imageView?.tintColor = .systemGray6
        
        button.addTarget(self, action: #selector(clickedPlus), for: .touchUpInside)
        return button
    }()
    
    @objc func clickedPlus() {
        iterations += 1
        minusButton.isEnabled = true
        
        if iterations == maximum {
            plusButton.isEnabled = false
        }
        
        iterationsLabel.text = "\(iterations)"
        generatorContentView.setIterations(iterations)
    }
    
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        button.imageView?.tintColor = .systemGray6
        button.isEnabled = false
        button.addTarget(self, action: #selector(clickedMinus), for: .touchUpInside)
        return button
    }()
    
    @objc func clickedMinus() {
        iterations -= 1
        plusButton.isEnabled = true
        
        if iterations == 0 {
            minusButton.isEnabled = false
        }
        
        iterationsLabel.text = "\(iterations)"
        generatorContentView.setIterations(iterations)
    }
    
    func setMaxIteration(_ iterations: Int) {
        self.iterations = iterations
        iterationsLabel.text = "\(iterations)"
        plusButton.isEnabled = false

    }
    
    
    init(frame: CGRect = .zero, generateContentView: GeneratorContentView) {
        self.generatorContentView = generateContentView
        super.init(frame: frame)
        
        setupView()
        
        setupDescriptionLabel()
        setupIterationsView()
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
    
    func setupIterationsView() {
        addSubview(iterationsLabel)
        iterationsLabel.snp.makeConstraints { make in
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
