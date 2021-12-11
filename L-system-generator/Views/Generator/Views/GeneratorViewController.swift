//
//  GeneratorViewController.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit
import Angelo

class GeneratorViewController: UIViewController {
    let state: GeneratorState
    var art: Art
    let viewModel: GeneratorViewModel
    
    lazy var rulesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.alpha = state == .edit ? 1 : 0
        return stack
    }()
    
    lazy var axiomView: GeneratorRuleView = {
        let view = GeneratorRuleView(type: .axiom, parent: self)
        view.label.text = art.axiomString
        return view
    }()
    
    lazy var ruleView: GeneratorRuleView = {
        let view = GeneratorRuleView(type: .rule, parent: self)
        view.label.text = art.ruleString
        return view
    }()
    
    lazy var lSystemView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = art.backgroundColor
        return view
    }()
    
    
    lazy var numbersStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.alpha = state == .edit ? 1 : 0
        return stack
    }()
    
    lazy var stepperView: GeneratorStepperView = {
        let view = GeneratorStepperView(parent: self)
        view.setIterations(art.iterations)
        return view
    }()
    
    lazy var rotationView: GeneratorRotationView = {
        let view = GeneratorRotationView(parent: self)
        view.setAngle(art.angle)
        return view
    }()
    
    lazy var colorsView: GeneratorColorsView = {
        let view = GeneratorColorsView(parent: self)
        view.alpha = state == .edit ? 1 : 0
        return view
    }()
    
    lazy var exportView: GeneratorExportView = {
        let view = GeneratorExportView(viewModel: viewModel, parent: self)
        view.alpha = state == .edit ? 0 : 1
        return view
    }()
    
    lazy var keyboardView: KeyboardView = {
        let view = KeyboardView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 250), parent: self)
        return view
    }()
    
    lazy var feedbackView: GeneratorFeedbackView = {
        let view = GeneratorFeedbackView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        
        setupRulesStack()
        setupLSystemView()
        setupNumbersStack()
        setupColorsView()
        
        setupExportView()
        
        setupFeedbackView()
        
        setupKeyboardView()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.state == .view {
                self.renderImage(width: 3.5)
            } else {
                self.renderImage()
            }
        }
    }
    
    private func setupNavigationBar() {
        let rightButton = UIBarButtonItem()
        if state == .edit {
            setSave(to: rightButton)
        } else {
            setEdit(to: rightButton)
        }
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setupRulesStack() {
        view.addSubview(rulesStack)
        rulesStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(56)
        }
        
        [
            axiomView,
            ruleView
        ].forEach { rulesStack.addArrangedSubview($0)  }
    }
    
    private func setupLSystemView() {
        view.addSubview(lSystemView)
        if state == .edit {
            lSystemView.snp.makeConstraints { make in
                make.top.equalTo(rulesStack.snp.bottom).offset(16)
                make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
                make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
                make.height.equalTo(UIScreen.main.bounds.height * 0.4)
            }
        } else {
            lSystemView.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
                make.height.equalTo(UIScreen.main.bounds.height * 0.6)
            }
        }
        
    }
    
    private func setupNumbersStack() {
        view.addSubview(numbersStack)
        numbersStack.snp.makeConstraints { make in
            make.top.equalTo(lSystemView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(70)
        }
        
        [
            stepperView,
            rotationView
        ].forEach { numbersStack.addArrangedSubview($0) }
    }
    
    private func setupColorsView() {
        view.addSubview(colorsView)
        colorsView.snp.makeConstraints { make in
            make.top.equalTo(numbersStack.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private func setupExportView() {
        view.addSubview(exportView)
        exportView.snp.makeConstraints { make in
            make.top.equalTo(lSystemView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(120)
        }
    }
    
    
    private func setupFeedbackView() {
        view.addSubview(feedbackView)
        feedbackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
    }
    
    private func setupKeyboardView() {
        view.addSubview(keyboardView)
    }
    
    func showKeyboard() {
        UIView.animate(withDuration: 0.3) {
            self.keyboardView.frame.origin.y = UIScreen.main.bounds.height - 250
        }
    }
    
    func hideKeyboard() {
        UIView.animate(withDuration: 0.3) {
            self.keyboardView.frame.origin.y = UIScreen.main.bounds.height
        }
        keyboardView.label = nil
        keyboardView.scrollView = nil
    }
    
    func setAxiom(_ axiom: String?) {
        guard let axiom = axiom else { return }
        if !axiom.contains("L") && !axiom.contains("C") && !axiom.contains("E") && !axiom.contains("D") {
            return
        }
        art.axiomString = axiom
        art.axiom = Art.getLSystemRule(for: art.axiomString, to: "axioma")
        renderImage()
    }
    
    func setRule(_ rule: String?) {
        guard let rule = rule else { return }
        if !rule.contains("L") && !rule.contains("C") && !rule.contains("E") && !rule.contains("D") {
            return
        }
        art.ruleString = rule
        art.rule = Art.getLSystemRule(for: art.ruleString, to: "L")
        renderImage()
    }
    
    func setIterations(_ iterations: Int) {
        art.iterations = iterations
        renderImage()
    }
    
    func setAngle(_ angle: Int) {
        art.angle = angle
        renderImage()
    }
    
    func setLSystemLineColor(_ color: UIColor?) {
        guard let color = color else { return }
        art.lineColor = color
        renderImage()
    }
    
    func setLSystemBackgroundColor(_ color: UIColor?) {
        guard let color = color else { return }
        art.backgroundColor = color
        lSystemView.backgroundColor = color
    }
    
    func renderImage(width: CGFloat = 3) {
        lSystemView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        checkSizeLimit()
        lSystemView.layer.addSublayer(viewModel.renderImageFrom(art: art, with: lSystemView.frame, lineWidth: width, padding: 32))
    }
    
    func checkSizeLimit() {
        let system = LSystem(rules: [Art.getLSystemRule(for: art.axiomString, to: "axioma"), Art.getLSystemRule(for: art.ruleString, to: "L")], transitions: [])
        var lSystemResult = system.produceOutput(input: "axioma", iterations: art.iterations)
        print(lSystemResult.outputElements.count)
        if system.produceOutput(input: "axioma", iterations: art.iterations+1).outputElements.count > 1500 {
            stepperView.plusButton.isEnabled = false
        }
        
        while lSystemResult.outputElements.count > 1500 {
            art.iterations -= 1
            lSystemResult = system.produceOutput(input: "axioma", iterations: art.iterations)
            stepperView.plusButton.isEnabled = false
            stepperView.setIterations(art.iterations)
        }
    }
    
    func setEdit(to barButton: UIBarButtonItem?){
        barButton?.target = self
        barButton?.action = #selector(clickedEdit)
        barButton?.style = .plain
        barButton?.title = "Editar"
    }
    
    @objc func clickedEdit() {
        setSave(to: navigationItem.rightBarButtonItem)
        
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.rulesStack.alpha = 1
            self.exportView.alpha = 0
            self.lSystemView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            
            self.lSystemView.snp.remakeConstraints { make in
                make.top.equalTo(self.rulesStack.snp.bottom).offset(16)
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
                make.height.equalTo(UIScreen.main.bounds.height * 0.4)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            self.renderImage()
            self.colorsView.alpha = 1
            self.numbersStack.alpha = 1
        }
    }
    
    func setSave(to barButton: UIBarButtonItem?) {
        barButton?.target = self
        barButton?.action = #selector(clickedSave)
        barButton?.style = .done
        barButton?.title = "Salvar"
    }
    
    @objc func clickedSave() {
        lSystemView.layer.cornerRadius = 0
        art.image = lSystemView.asImage()
        lSystemView.layer.cornerRadius = 10
        viewModel.saveArt(art)
        hideKeyboard()
        
        setEdit(to: navigationItem.rightBarButtonItem)
        self.numbersStack.alpha = 0
        self.colorsView.alpha = 0
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.rulesStack.alpha = 0
            self.exportView.alpha = 1
            self.lSystemView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            self.lSystemView.snp.remakeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
                make.height.equalTo(UIScreen.main.bounds.height * 0.6)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            self.renderImage(width: 3.5)
        }
    }
    
    init(state: GeneratorState, art: Art = Art(), viewModel: GeneratorViewModel) {
        self.state = state
        self.art = art
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum GeneratorState {
        case edit
        case view
    }
}
