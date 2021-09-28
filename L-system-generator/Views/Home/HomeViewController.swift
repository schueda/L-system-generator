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
        
        setupHomeContentView()
        setupNavigationBar()
    }
    
    func setupHomeContentView() {
        view.addSubview(homeContentView)
        homeContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavigationBar() {
    }
}
