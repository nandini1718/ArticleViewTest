//
//  ArticleDBManager.swift
//  ArticleView
//
//  Created by Nandini Mane on 02/10/20.
//  Copyright © 2020 Nandini Mane. All rights reserved.
//

import UIKit

extension ArticleModel {
    func insert(pageNumber:Int, json:String) {
        self.pageNumber = Int16(pageNumber)
        self.jsonObject = json
    }
}

class ArticleDBManager: NSObject {
    private let persistentStoreAdapter: PersistentStoreAdapter
    private let storeType: PersistentStoreType
    
    init(with persistentStoreAdapter: PersistentStoreAdapter, of type: PersistentStoreType = .coredata) {
        self.persistentStoreAdapter = persistentStoreAdapter
        self.storeType = type
    }
    
    func addUpdate(pageNumber:Int, json:String) {
        if self.storeType == .coredata {
            if let cdRecent = persistentStoreAdapter.object(for: "ArticleModel") as? ArticleModel {
                cdRecent.insert(pageNumber: pageNumber, json: json)
                self.persistentStoreAdapter.save()
            }
        }
    }
    
    func insertRecord(pageNumber:Int, json:String) {
        if self.storeType == .coredata {
            let predicate = NSPredicate(format: "pageNumber == %d", pageNumber)
            if let cdRecent = (self.persistentStoreAdapter.fetchResults(from: "ArticleModel", with: predicate, sortDescriptor: nil) as? [ArticleModel]), cdRecent.count != 0 {
                let cdRecentToBeUpdated = cdRecent.first
                cdRecentToBeUpdated?.pageNumber = Int16(pageNumber)
                cdRecentToBeUpdated?.jsonObject = json
                self.persistentStoreAdapter.save()
            }else {
                self.addUpdate(pageNumber: pageNumber, json: json)
            }
        }
    }
    
    func fetchRecord(pageNumber:Int) -> (pageNumber:Int, json:String) {
        if self.storeType == .coredata {
            let predicate = NSPredicate(format: "pageNumber == %d", pageNumber)
            if let cdRecent = (self.persistentStoreAdapter.fetchResults(from: "ArticleModel", with: predicate, sortDescriptor: nil) as? [ArticleModel]), cdRecent.count != 0 {
                let fetchedResult = cdRecent.first
                return ((Int(fetchedResult?.pageNumber ?? 0)),(fetchedResult?.jsonObject ?? ""))
            }
        }
        return (0,"")
    }
    
    func deleteAll() {
        if self.storeType == .coredata {
            self.persistentStoreAdapter.delete(from: "ArticleModel", with: nil)
        }
    }
    
    func save() {
        persistentStoreAdapter.save()
    }
}
