//
//  KeyboardView.swift
//  L-system-generator
//
//  Created by André Schueda on 06/12/21.
//

import UIKit

class KeyboardView: UIView {
    let parent: GeneratorViewController
    var label: UILabel? {
        didSet {
            scrollView?.backgroundColor = .clear
        }
    }
    var scrollView: UIScrollView?
    let drawButtons = ["L", "S", "C", "D", "E"]
    let rotationButtons = ["-", "+"]
    let branchButtons = ["[", "]"]
    
    lazy var drawLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "Desenhos"
        return label
    }()
    
    lazy var drawButtonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var rotationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "Rotação"
        return label
    }()
    
    lazy var rotationButtonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var branchLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "Ramo"
        return label
    }()
    
    lazy var branchButtonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "delete.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(removeLast), for: .touchUpInside)
        setStyle(to: button)
        return button
    }()
    
    @objc func removeLast() {
        _ = label?.text?.popLast()
        scrollView?.setContentOffset(CGPoint(x: label?.frame.width ?? 0, y: 0), animated: false)
        
        if label?.tag == 0 {
            parent.setAxiom(label?.text)
        } else {
            parent.setRule(label?.text)
        }
    }
    
    lazy var returnButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "return", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(returnClicked), for: .touchUpInside)
        setStyle(to: button)
        return button
    }()
    
    @objc func returnClicked() {
        scrollView?.backgroundColor = .clear
        parent.hideKeyboard()
        label = nil
        scrollView = nil
    }
    
    init(frame: CGRect = .zero, parent: GeneratorViewController) {
        self.parent = parent
        super.init(frame: frame)

        setupBluredBackground()
        
        setupDrawLabel()
        setupDrawButtonsStack()
        
        setupRotationLabel()
        setupRotationButtonsStack()
        
        setupBranchLabel()
        setupBranchButtonsStack()
        
        setupDeleteButton()
        setupReturnButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBluredBackground() {
        let blurEffect = UIBlurEffect(style: .systemThickMaterial)
        let bluredView = UIVisualEffectView(effect: blurEffect)
        addSubview(bluredView)
        bluredView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupDrawLabel() {
        addSubview(drawLabel)
        drawLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    private func setupDrawButtonsStack() {
        addSubview(drawButtonsStack)
        drawButtonsStack.snp.makeConstraints { make in
            make.top.equalTo(drawLabel.snp.bottom).offset(4)
            make.leading.equalTo(drawLabel)
        }
        setup(buttons: drawButtons, to: drawButtonsStack)
    }
    
    private func setupRotationLabel() {
        addSubview(rotationLabel)
        rotationLabel.snp.makeConstraints { make in
            make.top.equalTo(drawButtonsStack.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    private func setupRotationButtonsStack() {
        addSubview(rotationButtonsStack)
        rotationButtonsStack.snp.makeConstraints { make in
            make.top.equalTo(rotationLabel.snp.bottom).offset(4)
            make.leading.equalTo(rotationLabel)
        }
        setup(buttons: rotationButtons, to: rotationButtonsStack)
    }
    
    private func setupBranchLabel() {
        addSubview(branchLabel)
        branchLabel.snp.makeConstraints { make in
            make.leading.equalTo(rotationButtonsStack.snp.trailing).offset(32)
            make.top.equalTo(rotationLabel)
        }
    }
    
    private func setupBranchButtonsStack() {
        addSubview(branchButtonsStack)
        branchButtonsStack.snp.makeConstraints { make in
            make.leading.equalTo(branchLabel)
            make.top.equalTo(branchLabel.snp.bottom).offset(4)
        }
        setup(buttons: branchButtons, to: branchButtonsStack)
    }
    
    private func setup(buttons: [String], to stack: UIStackView) {
        buttons.forEach { symbol in
            let button = UIButton()
            button.setTitle(symbol, for: .normal)
            button.addTarget(self, action: #selector(addSymbol(_ :)), for: .touchUpInside)
            
            setStyle(to: button)
            
            button.snp.makeConstraints { make in
                make.width.equalTo(40)
                make.height.equalTo(40)
            }
            stack.addArrangedSubview(button)
        }
    }
    
    @objc func addSymbol(_ sender: UIButton) {
        label?.text? += sender.titleLabel?.text ?? ""
        scrollView?.setContentOffset(CGPoint(x: label?.frame.width ?? 0, y: 0), animated: false)
        
        if label?.tag == 0 {
            parent.setAxiom(label?.text)
        } else {
            parent.setRule(label?.text)
        }
    }
    
    private func setStyle(to button: UIButton) {
        button.backgroundColor = .systemGray5.withAlphaComponent(0.7)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
    }
    
    private func setupDeleteButton() {
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.leading.equalTo(drawButtonsStack.snp.trailing).offset(32)
            make.height.equalTo(40)
            make.top.equalTo(drawButtonsStack)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private func setupReturnButton() {
        addSubview(returnButton)
        returnButton.snp.makeConstraints { make in
            make.leading.equalTo(branchButtonsStack.snp.trailing).offset(32)
            make.height.equalTo(40)
            make.top.equalTo(rotationButtonsStack)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
