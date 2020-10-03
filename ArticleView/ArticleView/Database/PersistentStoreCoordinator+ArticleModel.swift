//
//  PersistentStoreCoordinator+ArticleModel.swift
//  ArticleView
//
//  Created by Nandini Mane on 02/10/20.
//  Copyright © 2020 Nandini Mane. All rights reserved.
//

import Foundation
extension PersistentStoreCoordinator {
    
    func addOrUpdateArticle(pageNumber:Int, json:String) {
        let store = ArticleDBManager(with: self.persistentStoreAdapter!, of: .coredata)
        store.insertRecord(pageNumber: pageNumber, json: json)
    }
    
    func fetchArticle(pageNumber:Int) -> (pageNumber:Int, json:String) {
        let store = ArticleDBManager(with: self.persistentStoreAdapter!, of: .coredata)
        let result = store.fetchRecord(pageNumber: pageNumber)
        return result
    }
    
    func deleteAllArticle() {
        let store = ArticleDBManager(with: self.persistentStoreAdapter!, of: .coredata)
        store.deleteAll()
    }
}
