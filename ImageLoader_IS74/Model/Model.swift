//
//  Model.swift
//  ImageLoader_IS74
//
//  Created by Артем Хребтов on 28.01.2022.
//

import Foundation
//MARK: Model for API
struct MyImage: Hashable, Codable {
    var albumId: Int
    var id: Int
    var title: String
    var url: String
    var thumbnailUrl: String
    }



