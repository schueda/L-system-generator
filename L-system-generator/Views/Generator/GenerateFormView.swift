//
//  GenerateFormView.swift
//  L-system-generator
//
//  Created by André Schueda on 30/09/21.
//

import UIKit

class GenerateFormView: UIView {
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setupBluredBackground()
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        addGestureRecognizer(gesture)
    }
    
    func setupBluredBackground() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let bluredView = UIVisualEffectView(effect: blurEffect)
        bluredView.frame = UIScreen.main.bounds
        addSubview(bluredView)
        
        layer.cornerRadius = 20
        clipsToBounds = true
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
}
