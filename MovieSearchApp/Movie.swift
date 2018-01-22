//
//  movies.swift
//  MovieSearchApp
//
//  Created by Sun&KK on 10/8/17.
//  Copyright © 2017 Washtinton University in St. Louis. All rights reserved.
//

import Foundation
// model movies, used for get searching information and save it
struct Movie {
    var title : String
    var image_url: String
    var id : Int
    var description: String
    
//    init(title: String, description: String, image_url: String) {
//        self.title = title
//        self.description = description
//        self.image_url = image_url
//        
//        
//    }
}

//class Book: NSObject, NSCoding {
//
//    var title: String
//    var author: String
//    var pageCount: Int
//
//    init(title: String, author: String, pageCount: Int) {
//        self.title = title
//        self.author = author
//        self.pageCount = pageCount
//    }
//
//    required convenience init?(coder aDecoder: NSCoder) {
//        guard let title = aDecoder.decodeObject(forKey: "title") as? String,
//            let author = aDecoder.decodeObject(forKey: "author") as? String
//            else {
//                return nil
//        }
//        let thePageCount = aDecoder.decodeInteger(forKey: "pageCount")
//
//        self.init(title: title, author: author, pageCount: thePageCount)
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(title, forKey: "title")
//        aCoder.encode(author, forKey: "author")
//        aCoder.encode(pageCount, forKey: "pageCount")
//    }
//}

