//
//  APIService.swift
//  ArticleView
//
//  Created by Nandini Mane on 01/10/20.
//  Copyright © 2020 Nandini Mane. All rights reserved.
//

import UIKit

class APIService: NSObject {

    
    func getArticles(currentPage:Int, completion : @escaping (Articles, String) -> ()){
        let sourcesURL = URL(string: "https://5e99a9b1bc561b0016af3540.mockapi.io/jet2/api/v1/blogs?page=\(currentPage)&limit=10")!

        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let jsonString = String(decoding: data, as: UTF8.self)
                let data = try! jsonDecoder.decode(Articles.self, from: data)
                completion(data, jsonString)
            }
        }.resume()
    }
}
