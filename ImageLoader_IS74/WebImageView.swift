//
//  WebImageView.swift
//  ImageLoader_IS74
//
//  Created by Артем Хребтов on 27.01.2022.
//

import Foundation
import UIKit

class WebImageView: UIImageView {
    private var currentUrlString: String?
    
    func set(imgUrl: String?){
        currentUrlString = imgUrl
        guard let imgUrl = imgUrl, let url = URL(string: imgUrl) else {
            self.image = nil
            return
        }
        
        if let cacheResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cacheResponse.data)
            print("cache")
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.handleLoadedImage(data: data, response: response)
                }
            }
        }
        dataTask.resume()
    }
    
    func handleLoadedImage(data: Data, response: URLResponse){
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
        
        if responseURL.absoluteString == currentUrlString {
            self.image = UIImage(data: data)
            print("download")
        }
    }
}
