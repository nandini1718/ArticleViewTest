//
//  PersistentStoreCoordinator.swift
//  ArticleView
//
//  Created by Nandini Mane on 02/10/20.
//  Copyright © 2020 Nandini Mane. All rights reserved.
//

import Foundation

enum PersistentStoreType {
    case userdefaults
    case keychain
    case coredata
}

fileprivate let persistentStoreName = "ArticleView"

class PersistentStoreCoordinator: NSObject {

    // MARK: - Properties
    
    // FIXME:- avoid singleton to use other store types
    static let sharedCoordinator = PersistentStoreCoordinator()

    let persistentStoreAdapter: PersistentStoreAdapter? = CoreDataStore.shared
    var persistentType: PersistentStoreType? = .coredata

    // MARK: - Initialization
    
    private override init() {
        super.init()
        
    }
    

    func initializeStore(with type: PersistentStoreType, _ completion: @escaping () -> Swift.Void) {
        self.persistentType = type
        switch type {
        case .userdefaults:
            break
        case .keychain:
            break
        case .coredata:
            self.configureCoreData{ completion() }
        }
    }
    
    func synchronized(_ completion: @escaping () -> Swift.Void) {
        guard self.persistentStoreAdapter != nil else {
            self.initializeStore(with: self.persistentType ?? .coredata, {
                completion()
            })
            return
        }
        completion()
    }
    
    private func configureCoreData(_ completion: @escaping () -> Swift.Void) {
    }
    
}
