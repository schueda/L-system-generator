//
//  GeneratorFeedbackView.swift
//  L-system-generator
//
//  Created by André Schueda on 09/12/21.
//

import UIKit

class GeneratorFeedbackView: UIView {
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        return spinner
    }()
    
    lazy var checkMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "checkmark.circle")
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupBluredView()
        setupSpinner()
        setupCheckMarkImageView()
    }
    
    private func setupView() {
        alpha = 0
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    private func setupBluredView() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let bluredView = UIVisualEffectView(effect: blurEffect)
        addSubview(bluredView)
        bluredView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupSpinner() {
        addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupCheckMarkImageView() {
        addSubview(checkMarkImageView)
        checkMarkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setToConcluded() {
        checkMarkImageView.alpha = 1
        spinner.stopAnimating()
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .allowAnimatedContent) {
            self.alpha = 1
        } completion: { _ in
            UIImageView.animate(withDuration: 0.4, delay: 0.7, options: .allowAnimatedContent) {
                self.alpha = 0
            }
        }
    }
    
    func setToLoading() {
        checkMarkImageView.alpha = 0
        spinner.startAnimating()
        
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1
        }
    }
}
