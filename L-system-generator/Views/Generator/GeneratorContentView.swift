//
//  GeneratorContentView.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit

class GeneratorContentView: UIView {
    lazy var wheelFormView: WheelFormView = {
        let view = WheelFormView()
        return view
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        addSubview(wheelFormView)
        wheelFormView.snp.makeConstraints { make in
            make.height.equalTo(wheelFormView.width)
            make.width.equalTo(wheelFormView.width)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
