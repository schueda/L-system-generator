//
//  GeneratorContentView.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit
import Angelo

class GeneratorContentView: UIView {
    
    let rules: [LSystemRule] = [
//        LSystemRule(input: "L", outputs: ["L","[","+","L","L","]","[","-","L","L","]","L","[","-","L","]","[","+","L","]","L"])
        LSystemRule(input: "L", outputs: ["L", "+", "L", "-", "-", "L", "+", "L"])
//        LSystemRule(input: "c", outputs: ["L", "+", "L", "+", "L", "+", "L"]),
//        LSystemRule(input: "L", outputs: ["L", "L", "+", "L", "+", "+", "L", "+", "L"])
    ]
    
    lazy var lSystemContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.clipsToBounds = true
        return view
    }()
    
    lazy var lSystemView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.clipsToBounds = true
        return view
    }()
    
    @objc func renderImage() {
        let system = LSystem(rules: rules, transitions: [])
        let renderer = Renderer(rotationAngle: CGFloat.pi * 80/180)
        let layer = renderer.generateLayer(by: system.produceOutput(input: "L", iterations: 5), frame: lSystemView.frame)
        lSystemView.layer.addSublayer(layer)
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupLSystemContainerView()
        setupLSystemView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.renderImage()
        }
    }
    
    func setupLSystemContainerView() {
        addSubview(lSystemContainerView)
        lSystemContainerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
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
