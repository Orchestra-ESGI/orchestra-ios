//
//  UIImageViewExtension.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 12/06/2021.
//

import UIKit
import RxCocoa
import RxSwift

extension UIImageView {

    private static let imageCache = NSCache<NSString, UIImage>()
    
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            self.image = nil
            //If imageurl's imagename has space then this line going to work for this
            let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                if let cachedImage = UIImageView.imageCache.object(forKey: NSString(string: imageServerUrl)) {
                self.image = cachedImage
            }

            if let url = URL(string: imageServerUrl) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        print("ERROR LOADING IMAGES FROM URL: \(error)")
                        DispatchQueue.main.async {
                            self.image = placeHolder
                        }
                        observer.onError(error!)
                    }
                    DispatchQueue.main.async {
                        if let data = data {
                            if let downloadedImage = UIImage(data: data) {
                                UIImageView.imageCache.setObject(downloadedImage, forKey: NSString(string: imageServerUrl))
                                self.image = downloadedImage
                                observer.onNext(true)
                            }
                        }
                    }
                }).resume()
            }
            
            return Disposables.create()
        }
    }
}
