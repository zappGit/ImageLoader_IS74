//
//  APILoader.swift.swift
//  ImageLoader_IS74
//
//  Created by Артем Хребтов on 27.01.2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let url = "https://jsonplaceholder.typicode.com/photos"
    
    func getImages(complition: @escaping([MyImage]?, Error?) -> Void){

        guard let urlString = URL(string: url) else {return}
        
        let task = URLSession.shared.dataTask(with: urlString) { data, response, error in
            if let error = error {
                complition(nil, error)
            }
        
            guard let data = data else {
                complition(nil, error)
                return
            }
            do {
                let jsonResult = try JSONDecoder().decode([MyImage].self, from: data)
                complition(jsonResult, nil)
            } catch let error {
                complition(nil, error)
            }
        }
        task.resume()
    }
}
