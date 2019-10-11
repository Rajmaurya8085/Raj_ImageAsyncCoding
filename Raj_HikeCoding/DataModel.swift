//
//  DataModel.swift
//  Raj_HikeCoding
//
//  Created by Interview on 03/08/19.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

struct Response:Codable {
    let stat:String
    let photos:Photos
}

struct Photos:Codable{
    let page:Int
    let pages:Int
    let perpage:Int
    var  photo:[DataModel] 
}

struct DataModel:Codable{
    let id :String
    let owner:String
    let secret:String
    let server:String
    let farm:Int
    let title:String
    let ispublic:Int
    let isfriend:Int
    let isfamily:Int
    let imageURL:String?
}



extension DataModel{
    
    var imageUrl:URL?{
        let urlString  =  baseURL + "\(farm)" + ".static.flickr.com/\(server)/\(id)_\(secret).jpg"
        guard  let url  = URL(string: urlString) else {return nil}
        return url
    }
}
