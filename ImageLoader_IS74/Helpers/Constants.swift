//
//  Constants.swift
//  ImageLoader_IS74
//
//  Created by Артем Хребтов on 29.01.2022.
//

import Foundation
import UIKit
//MARK: Common constants for the project
struct Constants {
    static let deviceWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    static let deviceHeight: CGFloat = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    static let spasing = CGFloat(10)
    static let numberOfColumns = 2
    static let miniImage = CGFloat(200)
    static let fullImage = CGFloat(600)
}
