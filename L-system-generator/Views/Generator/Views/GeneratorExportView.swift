//
//  GeneratorExportView.swift
//  L-system-generator
//
//  Created by André Schueda on 09/12/21.
//

import UIKit

class GeneratorExportView: UIView {
    let viewModel: GeneratorViewModel
    let parent: GeneratorViewController
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var exportImageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickedExportImage), for: .touchUpInside)
        let buttonView = ExportButtonView(type: .image)
        button.addSubview(buttonView)
        buttonView.snp.makeConstraints { $0.edges.equalToSuperview() }
        return button
    }()
    
    @objc func clickedExportImage() {
        viewModel.exportImageFrom(art: parent.art)
        parent.feedbackView.setToConcluded()
    }
    
    lazy var exportGifButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickedExportGif), for: .touchUpInside)
        let buttonView = ExportButtonView(type: .gif)
        button.addSubview(buttonView)
        buttonView.snp.makeConstraints { $0.edges.equalToSuperview() }
        return button
    }()
    
    @objc func clickedExportGif() {
        parent.feedbackView.setToLoading()
        DispatchQueue.main.async {
            self.viewModel.exportGifFrom(art: self.parent.art) {
                self.parent.feedbackView.setToConcluded()
            }
        }
    }
    
    init(frame: CGRect = .zero, viewModel: GeneratorViewModel, parent: GeneratorViewController) {
        self.viewModel = viewModel
        self.parent = parent
        super.init(frame: frame)
        
        setupStack()
        
        [
            exportImageButton,
            exportGifButton
        ].forEach { stack.addArrangedSubview($0) }
        
    }
    
    func setupStack() {
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
