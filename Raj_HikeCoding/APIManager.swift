//
//  APIManager.swift
//  Raj_HikeCoding
//
//  Created by Interview on 03/08/19.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation


import Foundation
import UIKit

private let attributedTitle  = "attributedTitle"
private let offlineMessage = "We are going to show previous saved"
private let dataSavingKey  = "savedData"
private let errorAlertTitle = "Error"
private var baseURlString = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1"
private let offlineErrorCode = -1009


class ApiManager:NSObject{
    
    class func makeApiCall(query:String, page :Int, result:@escaping (Photos)-> Void)
    {
        
        if query != ""{
            baseURlString = baseURlString + "&text=" + query
        }
        let urlData = baseURlString + "&page=" + "\(page)"
        guard let urlString = urlData.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        let urlRequest = URL(string: urlString)
        guard let url = urlRequest else{return}
        
        URLSession.shared.dataTask(with: url ) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                
                
                let jsonObject = try? JSONSerialization.jsonObject(with:data, options: [])
                guard let json = jsonObject as? [String :Any] else{return}
               // print(json)
                
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(Response.self, from: data)
               // print(gitData.stat)
                result(gitData.photos)
            } catch let err {
                print("Err", err)
            }
            }.resume()
    }
    
    class func showAlertTostMessage(title:String, message:String, controller:UIViewController,success:  (_ completed:Bool)->Void){
        
        let attributedString = NSAttributedString(string: title, attributes: [
            (kCTFontAttributeName as NSAttributedString.Key) : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor as NSAttributedString.Key : UIColor.red
            ])
        let alertController = UIAlertController(title: "" , message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.setValue(attributedString, forKey: attributedTitle)
        controller.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            alertController.dismiss(animated: false, completion: nil)
        }
    }
    
    class func getTopController() -> UIViewController{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let navController = appDelegate.window!.rootViewController as! UINavigationController
        return navController.topViewController!
    }
}
