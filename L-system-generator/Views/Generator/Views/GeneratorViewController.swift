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
    
    lazy var exportImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.setTitle("Salvar no dispositivo", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(clickedExportImage), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.alpha = state == .edit ? 0 : 1
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    @objc func clickedExportImage() {
        
        viewModel.exportImageFrom(art: art, stepperView: stepperView)
        clickedExportGif()
        //        feedbackView.setToConcluded()
    }
    
    
    lazy var keyboardView: KeyboardView = {
        let view = KeyboardView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 250), parent: self)
        return view
    }()
    
    lazy var feedbackView: GeneratorFeedbackView = {
        let view = GeneratorFeedbackView()
        
        return view
    }()
    
    
    @objc func clickedExportGif() {
        feedbackView.setToLoading()
        DispatchQueue.main.async {
            self.viewModel.exportGifFrom(art: self.art, stepperView: self.stepperView) {
                self.feedbackView.setToConcluded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        
        setupRulesStack()
        setupLSystemView()
        setupNumbersStack()
        setupColorsView()
        
        setupExportButton()
        setupGifButton()
        
        setupFeedbackView()
        
        setupKeyboardView()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.renderImage()
        }
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem()
        backButton.title = "Voltar"
        navigationItem.backBarButtonItem = backButton
        
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
        view.addSubview(lSystemContainerView)
        lSystemContainerView.snp.makeConstraints { make in
            make.top.equalTo(rulesStack.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
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
    
    private func setupNumbersStack() {
        view.addSubview(numbersStack)
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
    
    private func setupColorsView() {
        view.addSubview(colorsView)
        colorsView.snp.makeConstraints { make in
            make.top.equalTo(numbersStack.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private func setupExportButton() {
        view.addSubview(exportImageButton)
        exportImageButton.snp.makeConstraints { make in
            make.top.equalTo(lSystemContainerView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    private func setupGifButton() {
        
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
        UIView.animate(withDuration: 0.5) {
            self.keyboardView.frame.origin.y = UIScreen.main.bounds.height - 250
        }
    }
    
    func hideKeyboard() {
        UIView.animate(withDuration: 0.5) {
            self.keyboardView.frame.origin.y = UIScreen.main.bounds.height
        }
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
        lSystemContainerView.backgroundColor = color
        lSystemView.backgroundColor = color
    }
    
    func renderImage() {
        lSystemView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        lSystemView.layer.addSublayer(viewModel.renderImageFrom(art: art, with: lSystemView.frame, stepperView: stepperView, lineWidth: 3, padding: 8))
    }
    
    func setEdit(to barButton: UIBarButtonItem?){
        barButton?.target = self
        barButton?.action = #selector(clickedEdit)
        barButton?.style = .plain
        barButton?.title = "Editar"
    }
    
    @objc func clickedEdit() {
        setSave(to: navigationItem.rightBarButtonItem)
        rulesStack.alpha = 1
        numbersStack.alpha = 1
        colorsView.alpha = 1
        exportImageButton.alpha = 0
    }
    
    func setSave(to barButton: UIBarButtonItem?) {
        barButton?.target = self
        barButton?.action = #selector(clickedSave)
        barButton?.style = .done
        barButton?.title = "Salvar"
    }
    
    @objc func clickedSave() {
        art.image = lSystemView.asImage()
        viewModel.saveArt(art)
        
        setEdit(to: navigationItem.rightBarButtonItem)
        numbersStack.alpha = 0
        rulesStack.alpha = 0
        colorsView.alpha = 0
        exportImageButton.alpha = 1
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
