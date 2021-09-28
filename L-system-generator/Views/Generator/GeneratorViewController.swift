//
//  GeneratorViewController.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit

class GeneratorViewController: UIViewController {
    let type: GeneratorType
    
    lazy var generatorContentView: GeneratorContentView = {
        let view = GeneratorContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupGeneratorContentView()
        setupNavigationBar()
    }
    
    func setupGeneratorContentView() {
        view.addSubview(generatorContentView)
        generatorContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavigationBar() {
        let backButton = UIBarButtonItem()
        backButton.title = "Voltar"
        navigationItem.backBarButtonItem = backButton
        
        let rightButton = UIBarButtonItem()
        if type == .edit {
            setSave(to: rightButton)
        } else {
            setEdit(to: rightButton)
        }
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func setEdit(to barButton: UIBarButtonItem?){
        barButton?.target = self
        barButton?.action = #selector(clickedEdit)
        barButton?.style = .plain
        barButton?.title = "Editar"
    }
    
    @objc func clickedEdit() {
        setSave(to: navigationItem.rightBarButtonItem)
    }
    
    func setSave(to barButton: UIBarButtonItem?) {
        barButton?.target = self
        barButton?.action = #selector(clickedSave)
        barButton?.style = .done
        barButton?.title = "Salvar"
    }
    
    @objc func clickedSave() {
        navigationController?.popViewController(animated: true)
    }
    
    
    init(type: GeneratorType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum GeneratorType {
        case edit
        case view
    }
}
