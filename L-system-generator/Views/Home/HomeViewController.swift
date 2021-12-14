//
//  HomeViewController.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit

class HomeViewController: UIViewController {
    lazy var homeContentView: HomeContentView = {
        let view = HomeContentView(navigationController: navigationController)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DefaultAnalyticsService.shared.log(message: "HomeViewController viewed")
        
        setupHomeContentView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.heroNavigationAnimationType = .selectBy(presenting: .cover(direction: .left), dismissing: .uncover(direction: .right))
    }
    
    func setupHomeContentView() {
        view.addSubview(homeContentView)
        homeContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Voltar", style: .plain, target: nil, action: nil)
        
    }
}
