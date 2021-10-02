//
//  GeneratorRotationView.swift
//  L-system-generator
//
//  Created by André Schueda on 01/10/21.
//

import UIKit

class GeneratorRotationView: UIView {
    let generatorContentView: GeneratorContentView
    var angle: Int = 90
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "Rotação"
        return label
    }()
    
    lazy var angleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "\(angle)"
        return label
    }()
    
    lazy var angleSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.addTarget(self, action: #selector(changedSlider), for: .valueChanged)
        slider.addTarget(self, action: #selector(stoppedChangingSlider), for: .touchUpInside)
        return slider
    }()
    
    @objc func changedSlider() {
        let newAngle = Int(180 * angleSlider.value)
        angle = newAngle
        angleLabel.text = "\(newAngle)"
        generatorContentView.setRotationAngle(CGFloat(angle))
    }
    
    @objc func stoppedChangingSlider() {
    }
    
    init(frame: CGRect = .zero, generatorContentView: GeneratorContentView) {
        self.generatorContentView = generatorContentView
        super.init(frame: frame)
        
        setupView()
        
        setupDescriptionLabel()
        setupAngleLabel()
        setupAngleSlider()
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
        }
    }
    
    func setupAngleLabel() {
        addSubview(angleLabel)
        angleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.centerX.equalTo(descriptionLabel)
        }
    }
    
    func setupAngleSlider() {
        addSubview(angleSlider)
        angleSlider.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalTo(angleLabel)
            make.width.equalTo(100)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
