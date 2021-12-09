//
//  GalleryViewController.swift
//  L-system-generator
//
//  Created by André Schueda on 28/09/21.
//

import UIKit

class GalleryViewController: UIViewController {
    let artsRepository: ArtsRepository = UserDefaultsArtsRepository.shared
    var arts: [Art] = []
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: UIScreen.main.bounds.height * 0.357, left: 16, bottom: UIScreen.main.bounds.height * 0.422, right: 16)
        layout.minimumLineSpacing = 16
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    lazy var galleryPlaceholder: UILabel = {
        let label = UILabel()
        label.text = "As artes salvas no gerador ficarão aqui!"
        label.numberOfLines = 0
        label.backgroundColor = .systemGray5.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        setupNavigation()
    }

    override func viewWillAppear(_ animated: Bool) {
        arts = artsRepository.getAllArts()
        collectionView.reloadData()
        
        if arts.isEmpty {
            setupGaleryPlaceholder()
        }
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.addSubview(UIView())
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height + 100)
            make.center.equalToSuperview()
        }
        collectionView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.backgroundColor = .clear
    }

    func setupGaleryPlaceholder() {
        view.addSubview(galleryPlaceholder)
        galleryPlaceholder.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.width.equalTo(200)
            make.center.equalToSuperview()
        }
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(GeneratorViewController(type: .view, art: arts[indexPath.row], viewModel: GeneratorViewModel()), animated: true)
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell
        cell.setArt(arts[indexPath.row])
        return cell
    }
    
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 64)/3
        return CGSize(width: width, height: 1.3 * width)
    }
}
