//
//  Helpers.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/18/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImagesUsingCache(url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            self.image = cachedImage
            completion(cachedImage)
            return
        }
        
        let actualurl = URL(string: url)!
        
        let task = URLSession.shared.dataTask(with: actualurl) { (data, res, err) in
            
            if let data = data {
                DispatchQueue.main.async {
                    if let recImage = UIImage(data: data) {
                        imageCache.setObject(recImage, forKey: url as NSString)
                        self.image = recImage
                        completion(recImage)
                    }
                }
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap
            { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
