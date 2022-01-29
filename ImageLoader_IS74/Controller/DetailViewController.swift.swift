//
//  DetailViewController.swift.swift
//  ImageLoader_IS74
//
//  Created by Артем Хребтов on 29.01.2022.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    
    private let image: MyImage
    let fullImage = WebImageView()
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    
    
    init(with myImage: MyImage) {
        self.image = myImage
        self.fullImage.set(imgUrl: myImage.url)
        self.label.text = myImage.title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupUI()
    }
    
    private func setupUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
    }
    
    @objc func shareButtonTapped() {
        guard let image = fullImage.image else { return }
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
}


extension DetailViewController {
    private func setupConstraints() {
        fullImage.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(fullImage)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            fullImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: -50),
            fullImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fullImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fullImage.heightAnchor.constraint(equalToConstant: Constants.deviceWidth)
        ])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: fullImage.bottomAnchor,constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
