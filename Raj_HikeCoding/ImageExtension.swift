//
//  ImageExtension.swift
//  Raj_HikeCoding
//
//  Created by Interview on 03/08/19.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation
import UIKit


//var cache = NSCache<NSString,UIImage>()
//
//extension UIImageView {
//    func downloaded(from url: URL, complitionHandler displayImage:@escaping(UIImage)->Void) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
//
//        let imageUrl  = url
//        
//        if  let image  = cache.object(forKey: url.absoluteString as NSString){
//            displayImage(image)
//        }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                
//                else { return }
//            
//            if httpURLResponse.url != nil{
//                cache.setObject(image, forKey: httpURLResponse.url!.absoluteString as NSString)
//            }
//           if  httpURLResponse.url  == imageUrl{
//            displayImage(image)
//            }
//            
//            }.resume()
//    }
//    
//    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
//        guard let url = URL(string: link) else { return }
//       // downloaded(from: url, contentMode: mode)
//    }
//}
