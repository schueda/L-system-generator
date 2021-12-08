//
//  GeneratorRotationView.swift
//  L-system-generator
//
//  Created by André Schueda on 01/10/21.
//

import UIKit

class GeneratorRotationView: UIView {
    let parent: GeneratorViewController
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "Ângulo"
        return label
    }()
    
    lazy var angleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    lazy var angleSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.addTarget(self, action: #selector(changedSlider), for: .valueChanged)
        return slider
    }()
    
    @objc func changedSlider() {
        let newAngle = Int(180 * angleSlider.value)
        angleLabel.text = "\(newAngle)º"
        parent.setAngle(newAngle)
    }
    
    func setAngle(_ angle: Int) {
        angleSlider.value = Float(angle)/180
        angleLabel.text = "\(angle)º"
    }
    
    init(frame: CGRect = .zero, parent: GeneratorViewController) {
        self.parent = parent
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
            make.top.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    func setupAngleSlider() {
        addSubview(angleSlider)
        angleSlider.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(UIScreen.main.bounds.width/2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
