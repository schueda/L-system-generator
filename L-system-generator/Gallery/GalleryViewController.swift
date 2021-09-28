//
//  GalleryViewController.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit

class GalleryViewController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1000)
            make.center.equalToSuperview()
        }
        collectionView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
    }

}
