//
//  GeneratorViewController.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit
import Angelo

class GeneratorViewController: UIViewController {
    let type: GeneratorState
    var art: Art
    let viewModel: GeneratorViewModel
    
    lazy var rulesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.alpha = type == .edit ? 1 : 0
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
        stack.alpha = type == .edit ? 1 : 0
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
    
    lazy var keyboardView: KeyboardView = {
        let view = KeyboardView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 250), parent: self)
        return view
    }()
    
    @objc func clickedExportImage() {
        UIImageWriteToSavedPhotosAlbum(lSystemView.asImage(withScale: 10), nil, nil, nil)
        self.exportImageButton.isEnabled = false
        clickedExportGif()
    }
    
    @objc func clickedExportGif() {
        var images: [UIImage] = []
        let system = LSystem(rules: [art.axiom!, art.rule!], transitions: [])
        let lSystemResult = system.produceOutput(input: "axioma", iterations: art.iterations + 1)
        for angle in 0...180 {
            lSystemView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            let renderer = Renderer()
            let layer = renderer.generateLayer(byResult: lSystemResult,
                                               frame: lSystemView.frame,
                                               lineColor: art.lineColor ?? .appBlue,
                                               angle: CGFloat(angle) * CGFloat.pi/180)
            lSystemView.layer.addSublayer(layer)
            
            images.append(lSystemView.asImage(withScale: 1))
        }
        
        DispatchQueue.global(qos: .background).async {
            UIImage.animatedGif(from: images)
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
        if type == .edit {
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
        art.axiomString = axiom
        if !axiom.contains("L") && !axiom.contains("C") && !axiom.contains("E") && !axiom.contains("D") {
            return
        }
        art.axiom = Art.getLSystemRule(for: art.axiomString, to: "axioma")
        renderImage()
    }
    
    func setRule(_ rule: String?) {
        guard let rule = rule else { return }
        art.ruleString = rule
        if !rule.contains("L") && !rule.contains("C") && !rule.contains("E") && !rule.contains("D") {
            return
        }
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
        lSystemView.layer.addSublayer(viewModel.renderImageFrom(art, with: lSystemView.frame, stepperView: stepperView))
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
    
    init(type: GeneratorState, art: Art = Art(), viewModel: GeneratorViewModel) {
        self.type = type
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
