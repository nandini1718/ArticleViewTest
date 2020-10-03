//
//  ArticleViewModel.swift
//  ArticleView
//
//  Created by Nandini Mane on 01/10/20.
//  Copyright © 2020 Nandini Mane. All rights reserved.
//

import UIKit

class ArticleViewModel: NSObject {
    
    var isMoreDataPresent:Bool = true
    private var apiService : APIService!
    private(set) var articles : Articles! {
        didSet {
            self.bindViewModelToController(self.articles)
        }
    }
    
    var bindViewModelToController : ((Articles) -> ()) = {_ in }
    
    override init() {
        super.init()
        self.apiService =  APIService()
    }
    
    func callGetArticles(currentPage:Int) {
        
        if NetworkReachability.isConnectedToNetwork() {
            self.apiService.getArticles(currentPage: currentPage){ (response, json) in
                self.isMoreDataPresent = false
                if response.count != 0 {
                    self.isMoreDataPresent = true
                }
                PersistentStoreCoordinator.sharedCoordinator.addOrUpdateArticle(pageNumber: currentPage, json: json)
                 DispatchQueue.main.async {
                    self.articles = response
                }
            }
        }else {
            let result = PersistentStoreCoordinator.sharedCoordinator.fetchArticle(pageNumber: currentPage)
            if result.pageNumber != 0 && result.json != "" {
                let data = Data(result.json.utf8)
                let jsonDecoder = JSONDecoder()
                let response = try! jsonDecoder.decode(Articles.self, from: data)
                self.isMoreDataPresent = false
                if response.count != 0 {
                    self.isMoreDataPresent = true
                }
                DispatchQueue.main.async {
                    self.articles = response
                }
            }
        }
    }

}
