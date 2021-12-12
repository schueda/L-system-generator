//
//  GeneratorRuleView.swift
//  L-system-generator
//
//  Created by André Schueda on 30/09/21.
//

import UIKit

class GeneratorRuleView: UIView {
    let parent: GeneratorViewController
    let type: TextType
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = type == .axiom ? "Regra inicial" : "Regra para L"
        return label
    }()
    
    lazy var randomButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "dice"), for: .normal)
        button.imageView?.tintColor = .label
        button.addTarget(self, action: #selector(clickedRandom), for: .touchUpInside)
        return button
    }()
    
    @objc func clickedRandom() {
        let randomRule = RuleGenerator.shared.getRandomRule()
        label.text = randomRule
        
        DefaultAnalyticsService.shared.log(event: .randomized(field: type.rawValue))
        changedLabel(sender: label)
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.cornerRadius = 3
        scrollView.addTapGesture(tapNumber: 1, target: self, action: #selector(selectedScrollView))
        return scrollView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.tag = type == .axiom ? 0 : 1
        return label
    }()
    
    @objc func selectedScrollView() {
        scrollView.backgroundColor = .systemGray5
        if label.frame.width > scrollView.frame.width {
            scrollView.setContentOffset(CGPoint(x: label.frame.width - scrollView.frame.width + 4, y: 0), animated: false)
        }
        parent.showKeyboard(for: self)
    }
    
    @objc func changedLabel(sender: UILabel) {
        switch type {
        case .axiom:
            parent.setAxiom(sender.text)
        case .rule:
            parent.setRule(sender.text)
        }
    }
    
    init(frame: CGRect = .zero, type: TextType, parent: GeneratorViewController) {
        self.type = type
        self.parent = parent
        super.init(frame: frame)
        
        setupView()
        
        setupDescriptionLabel()
        setupRandomButton()
        setupScrollView()
        setupLabel()
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
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    func setupRandomButton() {
        addSubview(randomButton)
        randomButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    func setupScrollView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalTo(randomButton.snp.leading).offset(-8)
        }
    }
    
    func setupLabel() {
        scrollView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum TextType: String {
        case axiom = "axiom"
        case rule = "rule"
    }
}
