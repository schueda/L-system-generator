//
//  GeneratorViewController.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit

class GeneratorViewController: UIViewController {
    let artRepository: ArtsRepository = UserDefaultsArtsRepository.shared
    let type: GeneratorType
    var art: Art
    
    lazy var generatorContentView: GeneratorContentView = {
        let view = GeneratorContentView(type: type, art: art)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
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
        art.axiom = generatorContentView.axiomString
        art.rule = generatorContentView.ruleString
        art.iterations = generatorContentView.iterations
        art.angle = generatorContentView.angle
        art.backgroundColor = generatorContentView.lSystemView.backgroundColor
        art.lineColor = generatorContentView.lSystemLineColor
        art.image = generatorContentView.lSystemView.asImage()
        
        artRepository.saveArt(art)
    }
    
    init(type: GeneratorType, art: Art = Art()) {
        self.type = type
        self.art = art
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
