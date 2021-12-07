//
//  KeyboardView.swift
//  L-system-generator
//
//  Created by André Schueda on 06/12/21.
//

import UIKit

class KeyboardView: UIView {
    let parent: UIViewController
    
    init(frame: CGRect = .zero, parent: UIViewController) {
        self.parent = parent
        super.init(frame: frame)

        setupBluredBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBluredBackground() {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let bluredView = UIVisualEffectView(effect: blurEffect)
        addSubview(bluredView)
        bluredView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
