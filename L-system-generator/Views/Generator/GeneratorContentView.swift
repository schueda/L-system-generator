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
    let art: Art
    var lSystemResult: LSystemResult
    
    private var axiom: LSystemRule
    var axiomString: String
    func setAxiom(_ axiom: String?) {
        guard let axiom = axiom else { return }
        self.axiomString = axiom
        
        if !axiom.contains("L") && !axiom.contains("C") && !axiom.contains("E") && !axiom.contains("D") {
            return
        }
            
        var charArray: [String] = []
        axiom.forEach({ charArray.append($0.description) })
        self.axiom = LSystemRule(input: "axioma", outputs: charArray)
        
        renderImage()
    }
    
    private var rule: LSystemRule
    var ruleString: String
    func setRule(_ rule: String?) {
        guard let rule = rule else { return }
        self.ruleString = rule
        
        if !rule.contains("L") && !rule.contains("C") && !rule.contains("E") && !rule.contains("D") {
            return
        }
        
        var charArray: [String] = []
        rule.forEach({ charArray.append($0.description) })
        self.rule = LSystemRule(input: "L", outputs: charArray)
        
        renderImage()
    }
    
    var iterations: Int
    func setIterations(_ iterations: Int) {
        self.iterations = iterations
        
        renderImage()
    }
    
    var angle: Int
    func setAngle(_ angle: Int) {
        self.angle = angle
        
        renderImage()
    }
    
    var lSystemLineColor: UIColor
    func setLSystemLineColor(_ color: UIColor?) {
        guard let color = color else { return }
        lSystemLineColor = color
        
        renderImage()
    }
    
    var lSystemBackgroundColor: UIColor
    func setLSystemBackgroundColor(_ color: UIColor?) {
        guard let color = color else { return }
        lSystemBackgroundColor = color
        
        lSystemContainerView.backgroundColor = color
        lSystemView.backgroundColor = color
    }
    
    lazy var rulesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.alpha = type == .edit ? 1 : 0
        return stack
    }()
    
    lazy var axiomView: GeneratorTextFieldView = {
        let view = GeneratorTextFieldView(type: .axiom, generatorContentView: self)
        view.textField.text = art.axiom
        return view
    }()
    
    lazy var ruleView: GeneratorTextFieldView = {
        let view = GeneratorTextFieldView(type: .rule, generatorContentView: self)
        view.textField.text = art.rule
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
        view.backgroundColor = .appWhite
        view.clipsToBounds = true
        return view
    }()
    
    
    lazy var numbersStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.alpha = type == .edit ? 1 : 0
        return stack
    }()
    
    lazy var stepperView: GeneratorStepperView = {
        let view = GeneratorStepperView(generateContentView: self, iterations: art.iterations)
        view.setIterations(art.iterations)
        return view
    }()
    
    lazy var rotationView: GeneratorRotationView = {
        let view = GeneratorRotationView(generatorContentView: self)
        view.setAngle(art.angle)
        return view
    }()
    
    lazy var colorsView: GeneratorColorsView = {
        let view = GeneratorColorsView(generatorContentView: self)
        view.alpha = type == .edit ? 1 : 0
        return view
    }()
    
    lazy var exportImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.setTitle("Salvar no dispositivo", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(clickedExportImage), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.alpha = type == .edit ? 0 : 1
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitle("Salva", for: .disabled)
        return button
    }()
    
    @objc func clickedExportImage() {
        UIImageWriteToSavedPhotosAlbum(lSystemView.asImage(withScale: 10), nil, nil, nil)
        self.exportImageButton.isEnabled = false
        clickedExportGif()
    }
    
    @objc func clickedExportGif() {
        var images: [UIImage] = []
        for angle in 0...180 {
            self.angle = angle
            
            lSystemView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            let renderer = Renderer()
            let layer = renderer.generateLayer(byResult: lSystemResult,
                                               frame: lSystemView.frame,
                                               lineColor: lSystemLineColor,
                                               angle: CGFloat(angle) * CGFloat.pi/180)
            lSystemView.layer.addSublayer(layer)
            
            images.append(lSystemView.asImage(withScale: 3))
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            UIImage.animatedGif(from: images)
        }
    }
    
    func renderImage() {
        lSystemView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        var iterations = self.iterations + 1
        let system = LSystem(rules: [axiom, rule], transitions: [])
        var lSystemResult = system.produceOutput(input: "axioma", iterations: iterations)
        
        if system.produceOutput(input: "axioma", iterations: iterations+1).outputElements.count > 2500 {
            stepperView.plusButton.isEnabled = false
        }
    
        while lSystemResult.outputElements.count > 2500 {
            iterations -= 1
            lSystemResult = system.produceOutput(input: "axioma", iterations: iterations)
            stepperView.plusButton.isEnabled = false
        }
        
        
        let renderer = Renderer()
        let layer = renderer.generateLayer(byResult: lSystemResult,
                                           frame: lSystemView.frame,
                                           lineColor: lSystemLineColor,
                                           angle: CGFloat(angle) * CGFloat.pi/180)
        lSystemView.layer.addSublayer(layer)
    }
    
    init(frame: CGRect = .zero, type: GeneratorViewController.GeneratorType, art: Art) {
        self.art = art
        self.axiom = LSystemRule(input: "axioma", outputs: art.axiom.asArray())
        self.axiomString = art.axiom
        self.rule = LSystemRule(input: "L", outputs: art.rule.asArray())
        self.ruleString = art.rule
        
        self.lSystemBackgroundColor = art.backgroundColor ?? .appWhite
        self.lSystemLineColor = art.lineColor ?? .appBlue
        self.iterations = art.iterations
        self.angle = art.angle
        
        let system = LSystem(rules: [axiom, rule], transitions: [])
        self.lSystemResult = system.produceOutput(input: "axioma", iterations: iterations + 1)
        
        self.type = type
        super.init(frame: frame)
        
        setupRulesStack()
        setupLSystemView()
        setupNumbersStack()
        setupColorsView()
        setupExportButton()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.renderImage()
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
        lSystemContainerView.backgroundColor = art.backgroundColor
        
        lSystemContainerView.addSubview(lSystemView)
        lSystemView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        lSystemView.backgroundColor = art.backgroundColor
    }
    
    func setupNumbersStack() {
        addSubview(numbersStack)
        numbersStack.snp.makeConstraints { make in
            make.top.equalTo(lSystemContainerView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(70)
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
    
    func setupExportButton() {
        addSubview(exportImageButton)
        exportImageButton.snp.makeConstraints { make in
            make.top.equalTo(lSystemContainerView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
