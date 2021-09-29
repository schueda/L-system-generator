//
//  WheelFormView.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit

class WheelFormView: UIView {
    let width = UIScreen.main.bounds.width - 32
    var rotationAngle: CGFloat = 0
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    lazy var testLabel: UILabel = {
        let label = UILabel()
        label.text = "amsldkjas"
        return label
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        layer.cornerRadius = width/2
        clipsToBounds = true
        
        [
            .right,
            .left,
        ].forEach({ self.createSwipeGestureRecognizer(for: $0) })
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(testLabel)
        testLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createSwipeGestureRecognizer(for direction: UISwipeGestureRecognizer.Direction) {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizer.direction = direction
        
        
        addGestureRecognizer(swipeGestureRecognizer)
    }
    
    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
            case .right:
                UIView.animate(withDuration: 0.3, delay: 0, options: []) {
                    self.rotationAngle += CGFloat.pi/2
                    self.contentView.transform = CGAffineTransform(rotationAngle: self.rotationAngle)
                } completion: { completed in
                    let haptic = UIImpactFeedbackGenerator(style: .heavy)
                    haptic.impactOccurred()
                }
            case .left:
                UIView.animate(withDuration: 0.3, delay: 0, options: []) {
                    self.rotationAngle -= CGFloat.pi/2
                    self.contentView.transform = CGAffineTransform(rotationAngle: self.rotationAngle)
                } completion: { completed in
                    let haptic = UIImpactFeedbackGenerator(style: .heavy)
                    haptic.impactOccurred()
                }
            default:
                print("shouldn't be running")
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
