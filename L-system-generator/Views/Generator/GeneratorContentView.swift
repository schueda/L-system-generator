//
//  GeneratorContentView.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit
import Angelo

class GeneratorContentView: UIView {
    let type: GeneratorViewController.GeneratorType
    
    var axiom: LSystemRule?
    var rule: LSystemRule?
    var iterations: Int?
    var rotationAngle: CGFloat? = CGFloat.pi * 90/180
    
    
    lazy var rulesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var axiomView: GeneratorTextFieldView = {
        let view = GeneratorTextFieldView(type: .axiom)
        return view
    }()
    
    lazy var ruleView: GeneratorTextFieldView = {
        let view = GeneratorTextFieldView(type: .rule)
        return view
    }()
    
    
    lazy var lSystemContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    lazy var lSystemView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    
    lazy var numbersStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var stepperView: GeneratorStepperView = {
        let view = GeneratorStepperView()
        return view
    }()
    
    lazy var rotationView: GeneratorRotationView = {
        let view = GeneratorRotationView()
        return view
    }()
    
    lazy var colorsView: GeneratorColorsView = {
        let view = GeneratorColorsView()
        return view
    }()
    
    func renderImage() {
        guard let axiom = axiom,
              let rule = rule,
              let iterations = iterations,
              let rotationAngle = rotationAngle
        else { return }
        
        lSystemView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let system = LSystem(rules: [axiom, rule], transitions: [])
        let renderer = Renderer(rotationAngle: rotationAngle)
        let layer = renderer.generateLayer(by: system.produceOutput(input: "A", iterations: iterations), frame: lSystemView.frame)
        lSystemView.layer.addSublayer(layer)
    }
    
    init(frame: CGRect = .zero, type: GeneratorViewController.GeneratorType) {
        self.type = type
        super.init(frame: frame)
        
        setupRulesStack()
        setupLSystemView()
        setupNumbersStack()
        setupColorsView()
    }
    
    func setupRulesStack() {
        addSubview(rulesStack)
        rulesStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(56)
        }
        
        [
            axiomView,
            ruleView
        ].forEach { rulesStack.addArrangedSubview($0)  }
    }
    
    
    func setupLSystemView() {
        addSubview(lSystemContainerView)
        lSystemContainerView.snp.makeConstraints { make in
            make.top.equalTo(rulesStack.snp.bottom).offset(16)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.height.equalTo(UIScreen.main.bounds.height * 0.4)
        }
        
        lSystemContainerView.addSubview(lSystemView)
        lSystemView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func setupNumbersStack() {
        addSubview(numbersStack)
        numbersStack.snp.makeConstraints { make in
            make.top.equalTo(lSystemContainerView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(56)
        }
        
        [
            stepperView,
            rotationView
        ].forEach { numbersStack.addArrangedSubview($0) }
    }
    
    func setupColorsView() {
        addSubview(colorsView)
        colorsView.snp.makeConstraints { make in
            make.top.equalTo(numbersStack.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
