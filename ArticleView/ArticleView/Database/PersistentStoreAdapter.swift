//
//  PersistentStoreAdapter.swift
//  ArticleView
//
//  Created by Nandini Mane on 02/10/20.
//  Copyright © 2020 Nandini Mane. All rights reserved.
//

import Foundation

protocol PersistentStoreAdapter {
   func insert(_ object: AnyObject, into entity: String)
   func update(_ object: AnyObject, of entity: String)
   func delete(from entity: String, with predicate: NSPredicate?)
   func query(_ query: String, to entity: String) -> [AnyObject]
   func fetchResults(from entity: String, with predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?) -> [AnyObject]
   func object(for anEntity: String) -> AnyObject
   func save()
}
