//
//  ViewController.swift
//  ImageLoader_IS74
//
//  Created by Артем Хребтов on 27.01.2022.
//

import UIKit



class ViewController: UIViewController {
    
    
    var dataSourse: UICollectionViewDiffableDataSource<Section,MyImage>?
    var collectionView: UICollectionView!
    var images: [MyImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureCollectionView()
        configureDataSourse()
        getImages()
    }
    
    
    func getImages(){
        NetworkManager.shared.getImages { [weak self] data, error in
            if let error = error {
                print ("error", error)
                return
            }
            guard let downloadImages = data else { return }
            self?.images = downloadImages
            DispatchQueue.main.async {
                self?.dataSnapshot(items: downloadImages)
            }
            
        }
    }

    //MARK: Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Галерея"
    }
    private func configure<T: ConfiguringCell>(cellType: T.Type, with value: MyImage, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseID, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        cell.configureCell(with: value)
        return cell
    }
    private func configureDataSourse() {
        dataSourse = UICollectionViewDiffableDataSource<Section,MyImage>(collectionView: collectionView, cellProvider: { collectionView, indexPath, image in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .imageGallery:
                return self.configure(cellType: ImageCell.self, with: image, for: indexPath)
            }
        })
    }
    private func dataSnapshot(items: [MyImage]){
        var snapshot = NSDiffableDataSourceSnapshot<Section,MyImage>()
        snapshot.appendSections([.imageGallery])
        snapshot.appendItems(items, toSection: .imageGallery)
        dataSourse?.apply(snapshot, animatingDifferences: true)
    }
    private func reloadSnap(for items: [MyImage]){
        guard var snap = dataSourse?.snapshot() else { return }
        snap.deleteAllItems()
        snap.appendSections([.imageGallery])
        snap.appendItems(items, toSection: .imageGallery)
        dataSourse?.apply(snap, animatingDifferences: true, completion: nil)
                
    }
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
    }
    
    private func createCompositionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(200))
        
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: 2)
        
        let spasing = CGFloat(10)
        group.interItemSpacing = .fixed(spasing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spasing
        section.contentInsets = NSDirectionalEdgeInsets(top: spasing, leading: spasing, bottom: spasing, trailing: spasing)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

