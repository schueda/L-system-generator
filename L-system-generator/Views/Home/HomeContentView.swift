//
//  HomeContentView.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit
import Angelo

class HomeContentView: UIView {
    let navigationController: UINavigationController?
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        generateBackground(on: view)
        return view
    }()
    
    func generateBackground(on view: UIView) {
        let sublayersCount: Int = view.layer.sublayers?.count ?? 0
        if sublayersCount > 70 {
            view.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        }
        
        let colors = UIColor.getRandomPair()
        view.backgroundColor = colors.background
        
        let axiom = LSystemRule(input: "axiom", outputs: RuleGenerator.shared.getRandomRule().asArray())
        let rule = LSystemRule(input: "L", outputs: RuleGenerator.shared.getRandomRule().asArray())
        let result = LSystem(rules: [axiom, rule], transitions: []).produceOutput(input: "axiom", iterations: 3)
        
        let layer = Renderer().generateLayer(byResult: result,
                                             frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
                                             lineColor: colors.line,
                                             angle: CGFloat.pi * CGFloat(Int.random(in: 1...179))/180,
                                             lineWidth: 5, padding: 0)
        view.layer.addSublayer(layer)
    }
    
    lazy var gradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
        view.addTapGesture(tapNumber: 1, target: self, action: #selector(tappedGradient))
        return view
    }()
    
    var tapCount = 0
    @objc func tappedGradient() {
        generateBackground(on: backgroundView)
        tapCount += 1
    }
    
    lazy var buttonsView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    lazy var generatorButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickedGenerator), for: .touchUpInside)
        
        let buttonView = HomeButtonView(type: .generator)
        button.addSubview(buttonView)
        buttonView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return button
    }()
    
    @objc func clickedGenerator() {
        navigationController?.pushViewController(GeneratorViewController(state: .edit, viewModel: GeneratorViewModel()), animated: true)
    }
    
    lazy var galleryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickedGallery), for: .touchUpInside)
        
        let buttonView = HomeButtonView(type: .gallery)
        button.addSubview(buttonView)
        buttonView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return button
    }()
    
    @objc func clickedGallery() {
        navigationController?.pushViewController(GalleryViewController(), animated: true)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 41, weight: .bold)
        label.text = "L-systems"
        label.textColor = .appWhite
        return label
    }()
    
    init(frame: CGRect = .zero, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        super.init(frame: frame)
        
        setupBackgroundView()
        setupGradientView()
        setupButtonsView()
        setupTitleLabel()
    }
    
    func setupBackgroundView() {
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupGradientView() {
        addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupButtonsView() {
        addSubview(buttonsView)
        [
            generatorButton,
            galleryButton
        ].forEach { buttonsView.addArrangedSubview($0) }
        buttonsView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-32)
        }
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(buttonsView.snp.top).offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
