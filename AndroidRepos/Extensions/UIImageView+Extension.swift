//
//  UIImageView+Extension.swift
//  AndroidRepos
//
//  Created by Marc Jardine Esperas on 2/27/22.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImage(_ urlString: String, isInverted: Bool) {

        self.image = nil

        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = cachedImage
            return
        }

        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL")
                    return
                }

                DispatchQueue.main.async {
                    if let data = data {
                        if let image = UIImage(data: data) {
                            imageCache.setObject(image, forKey: NSString(string: urlString))
                            self.image = image
                        }
                    }
                }

            }).resume()
        }
    }

}
