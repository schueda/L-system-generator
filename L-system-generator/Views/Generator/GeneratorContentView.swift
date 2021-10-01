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
        setupLSystemContainerView()
        setupLSystemView()
        
    }
    
    func setupLSystemContainerView() {
        addSubview(lSystemContainerView)
        lSystemContainerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.5)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
    }
    
    func setupLSystemView() {
        lSystemContainerView.addSubview(lSystemView)
        lSystemView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
