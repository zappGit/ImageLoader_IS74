//
//  ImageCell.swift
//  ImageLoader_IS74
//
//  Created by Артем Хребтов on 27.01.2022.
//

import UIKit

protocol ConfiguringCell {
    static var reuseID: String { get }
    func configureCell(with value: MyImage)
}

class ImageCell: UICollectionViewCell, ConfiguringCell {
    
    static let reuseID = "imageCell"
    let cellImage = WebImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 15
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with value: MyImage) {
        cellImage.set(imgUrl: value.thumbnailUrl)
       
    }
}

extension ImageCell {
    private func setupConstraints(){
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.adjustsImageSizeForAccessibilityContentSizeCategory = true
        contentView.addSubview(cellImage)
        
        NSLayoutConstraint.activate([
           cellImage.topAnchor.constraint(equalTo: contentView.topAnchor),
           cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
           cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
