//
//  GenerateFormView.swift
//  L-system-generator
//
//  Created by André Schueda on 30/09/21.
//

import UIKit
import Angelo

class GenerateFormView: UIView {
    let contentView: GeneratorContentView
    
    lazy var axiomTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Axioma"
        textField.delegate = self
        return textField
    }()
    
    lazy var firstRuleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Regra para L"
        textField.delegate = self
        return textField
    }()
    
    lazy var iterationStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.maximumValue = 7
        stepper.minimumValue = 1
        stepper.stepValue = 1
        stepper.addTarget(self, action: #selector(changeIteration), for: .touchUpInside)
        return stepper
    }()
    
    @objc func changeIteration() {
        contentView.iterations = Int(iterationStepper.value)
        contentView.renderImage()
    }
    
    init(frame: CGRect = .zero, contentView: GeneratorContentView) {
        self.contentView = contentView
        super.init(frame: frame)
        
        setupBluredBackground()
        setupGestures()
        
        setupAxiomTextField()
        setupFirstRuleTextField()
        setupIterationStepper()
    }
    
    func setupBluredBackground() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let bluredView = UIVisualEffectView(effect: blurEffect)
        bluredView.frame = UIScreen.main.bounds
        addSubview(bluredView)
        
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    func setupGestures() {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        addGestureRecognizer(gesture)
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        frame = CGRect(x: 0, y: frame.minY + translation.y, width: frame.width, height: frame.height)
        
        let hiddenYPosition = UIScreen.main.bounds.height - 90
        let showingYPosition = UIScreen.main.bounds.height * 0.4
        let betweenPositions = (hiddenYPosition + showingYPosition)/2
        
        let yPosition = (frame.minY + translation.y) < betweenPositions ? showingYPosition : hiddenYPosition
        
        if (frame.minY + translation.y) < 100 {
            frame = CGRect(x: 0, y: 100, width: frame.width, height: frame.height)
        }
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: 0.3) {
                self.frame = CGRect(x: 0, y: yPosition, width: self.frame.width, height: self.frame.height)
            }
        }
        recognizer.setTranslation(.zero, in: self)
    }
    
    func setupAxiomTextField() {
        addSubview(axiomTextField)
        axiomTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func setupFirstRuleTextField() {
        addSubview(firstRuleTextField)
        firstRuleTextField.snp.makeConstraints { make in
            make.top.equalTo(axiomTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func setupIterationStepper() {
        addSubview(iterationStepper)
        iterationStepper.snp.makeConstraints { make in
            make.top.equalTo(firstRuleTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        UIView.animate(withDuration: 0.3, delay: 0.3) {
            let yComponent = UIScreen.main.bounds.height - 90
            self.frame = CGRect(x: 0, y: yComponent, width: self.frame.width, height: self.frame.height)
        }
    }
}

extension GenerateFormView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == axiomTextField {
            var charArray: [String] = []
            guard let text = textField.text else { return }
            text.forEach({ charArray.append($0.description) })
            contentView.axiom = LSystemRule(input: "A", outputs: charArray)
            contentView.renderImage()
        }
        if textField == firstRuleTextField {
            var charArray: [String] = []
            guard let text = textField.text else { return }
            text.forEach({ charArray.append($0.description) })
            contentView.rule = LSystemRule(input: "L", outputs: charArray)
            contentView.renderImage()
        }
    }
}
