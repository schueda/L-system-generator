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
    
    private var axiom: LSystemRule?
    func setAxiom(_ axiom: String?) {
        guard let axiom = axiom else { return }
        
        
        if !axiom.contains("L") && !axiom.contains("C") && !axiom.contains("E") && !axiom.contains("D") {
            return
        }
            
        var charArray: [String] = []
        axiom.forEach({ charArray.append($0.description) })
        self.axiom = LSystemRule(input: "A", outputs: charArray)
        
        renderImage()
    }
    
    private var rule: LSystemRule?
    func setRule(_ rule: String?) {
        guard let rule = rule else { return }
        
        if !rule.contains("L") && !rule.contains("C") && !rule.contains("E") && !rule.contains("D") {
            return
        }
        
        var charArray: [String] = []
        rule.forEach({ charArray.append($0.description) })
        self.rule = LSystemRule(input: "L", outputs: charArray)
        
        renderImage()
    }
    
    var iterations: Int = 0
    func setIterations(_ iterations: Int) {
        self.iterations = iterations
        
        renderImage()
    }
    
    private var rotationAngle: CGFloat = CGFloat.pi * 90/180
    func setRotationAngle(_ angle: CGFloat) {
        rotationAngle = CGFloat.pi * angle/180
        
        renderImage()
    }
    
    private var lSystemLineColor: UIColor = .appBlue
    func setLSystemLineColor(_ color: UIColor?) {
        guard let color = color else { return }
        lSystemLineColor = color
        
        renderImage()
    }
    
    func setLSystemBackgroundColor(_ color: UIColor?) {
        guard let color = color else { return }
        lSystemContainerView.backgroundColor = color
    }
    
    lazy var rulesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var axiomView: GeneratorTextFieldView = {
        let view = GeneratorTextFieldView(type: .axiom, generatorContentView: self)
        return view
    }()
    
    lazy var ruleView: GeneratorTextFieldView = {
        let view = GeneratorTextFieldView(type: .rule, generatorContentView: self)
        return view
    }()
    
    
    lazy var lSystemContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite
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
        let view = GeneratorStepperView(generateContentView: self)
        return view
    }()
    
    lazy var rotationView: GeneratorRotationView = {
        let view = GeneratorRotationView(generatorContentView: self)
        return view
    }()
    
    lazy var colorsView: GeneratorColorsView = {
        let view = GeneratorColorsView(generatorContentView: self)
        return view
    }()
    
    func renderImage() {
        guard let axiom = axiom,
              let rule = rule
        else { return }
        stepperView.plusButton.isEnabled = true
        
        lSystemView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        var iterations = self.iterations + 1
        let system = LSystem(rules: [axiom, rule], transitions: [])
        var lSystemResult = system.produceOutput(input: "A", iterations: iterations)
    
        while lSystemResult.outputElements.count > 2500 {
            iterations -= 1
            lSystemResult = system.produceOutput(input: "A", iterations: iterations)
            stepperView.setMaxIteration(iterations - 1)
        }
        
        
        let renderer = Renderer()
        let layer = renderer.generateLayer(byResult: lSystemResult,
                                           frame: lSystemView.frame,
                                           lineColor: lSystemLineColor,
                                           rotationAngle: rotationAngle)
        lSystemView.layer.addSublayer(layer)
    }
    
    init(frame: CGRect = .zero, type: GeneratorViewController.GeneratorType) {
        self.type = type
        super.init(frame: frame)
        
        setupRulesStack()
        setupLSystemView()
        setupNumbersStack()
        setupColorsView()
        
        let randomAxiom = RuleGenerator.shared.getRamdomRule()
        self.axiomView.textField.text = randomAxiom
        let randomRule = RuleGenerator.shared.getRamdomRule()
        self.ruleView.textField.text = randomRule
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setAxiom(randomAxiom)
            self.setRule(randomRule)            
        }
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
