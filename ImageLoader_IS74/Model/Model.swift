//
//  Model.swift
//  ImageLoader_IS74
//
//  Created by Артем Хребтов on 28.01.2022.
//

import Foundation

struct MyImage: Hashable, Codable, Equatable {
    
    var albumId: Int
    var id: Int
    var title: String
    var url: String
    var thumbnailUrl: String
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: MyImage, rhs: MyImage) -> Bool {
        return lhs.id == rhs.id && lhs.albumId == rhs.albumId && lhs.title == rhs.title && lhs.url == rhs.url && lhs.thumbnailUrl == rhs.thumbnailUrl
    }
}
typealias Images = [MyImage]

