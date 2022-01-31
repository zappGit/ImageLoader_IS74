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
    //MARK: Get images from API
    func getImages(){
        NetworkManager.shared.getImages { [weak self] data, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let downloadImages = data else { return }
            self?.images = downloadImages
            DispatchQueue.main.async {
                self?.dataSnapshot()
            }
        }
    }
    //MARK: Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Gallery"
    }
    //MARK: Collection view
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
        collectionView.delegate = self
    }
}
//MARK: UICollectionViewDelegate. Push to DetailViewController
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = self.dataSourse?.itemIdentifier(for: indexPath) else { return }
        let detailViewController = DetailViewController(with: image)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
//MARK: DiffableDataSource
extension ViewController {
    //Congigure cell
    private func configure<T: ConfiguringCell>(cellType: T.Type, with value: MyImage, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseID, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        cell.configureCell(with: value)
        return cell
    }
    //Configure Data sourse
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
    //Create snapshot
    private func dataSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section,MyImage>()
        snapshot.appendSections([.imageGallery])
        snapshot.appendItems(images, toSection: .imageGallery)
        dataSourse?.apply(snapshot, animatingDifferences: true)
    }
}
//MARK: Make constraints
extension ViewController {
    private func createCompositionLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(Constants.miniImage))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: Constants.numberOfColumns)
        group.interItemSpacing = .fixed(Constants.spasing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.spasing
        section.contentInsets = NSDirectionalEdgeInsets(top: Constants.spasing, leading: Constants.spasing, bottom: Constants.spasing, trailing: Constants.spasing)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
