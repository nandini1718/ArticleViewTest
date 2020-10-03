//
//  CoreDataStore+PersistentStoreAdapter.swift
//  ArticleView
//
//  Created by Nandini Mane on 02/10/20.
//  Copyright © 2020 Nandini Mane. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataStore: PersistentStoreAdapter {
    func insert(_ object: AnyObject, into entity: String) {
        
    }
    
    
    

    func object(for anEntity: String) -> AnyObject {
        return self.managedObject(for: anEntity)
    }
    
    func save() {
        CoreDataStore.saveContext()
    }
    
    static var shared = CoreDataStore()
    
    
    // MARK:- UPDATE
    
    func update(_ object: AnyObject, of entity: String) {
         // Log.info?.message("\(#function) <===")
    }
    
    // MARK:- DELETE
    
    func delete(from entity: String, with predicate: NSPredicate? = nil) {
         // Log.info?.message("\(#function) <===")
        self.deleteData(from: entity, with: predicate)
    }
    
  

    
    // MARK:- READ
    
    func query(_ query: String, to entity: String) -> [AnyObject] {
        return []
    }
    
    func fetchResults(from entity: String, with predicate: NSPredicate? = nil, sortDescriptor: NSSortDescriptor? = nil) -> [AnyObject] {
        return self.fetch(from: entity, with: predicate, sortDescriptor: sortDescriptor)
    }
    
    
    // MARK: - Member Functions
    
    private func managedObject(for anEntityName: String) -> NSManagedObject {
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: anEntityName, into: (CoreDataStore.managedObjectContext))
        return managedObject
    }
    
    private func fetch(from entity: String, with predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?) -> [NSManagedObject] {
        var managedObjects = [NSManagedObject]()
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        if let predicate = predicate {
            fetchrequest.predicate = predicate
        }
        if let sortDescriptor = sortDescriptor {
            fetchrequest.sortDescriptors?.append(sortDescriptor)
        }
        do {
            managedObjects = try CoreDataStore.managedObjectContext.fetch(fetchrequest) as! [NSManagedObject]
        } catch {
             // Log.error?.message("\(#function):Error:\(error.localizedDescription)")
        }
        return managedObjects
    }
    
    private func deleteData(from entity: String, with predicate: NSPredicate?) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        do {
            let fetchs = try CoreDataStore.managedObjectContext.fetch(fetchRequest)
        for fetch in fetchs{
            CoreDataStore.managedObjectContext.delete(fetch as! NSManagedObject)
        }
//
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//            _ = try CoreDataStore.managedObjectContext.execute(deleteRequest)
            CoreDataStore.saveContext()
             // Log.info?.message("\(#function):\(result.description)")
        } catch {
            print(":Error:\(error.localizedDescription)")
        }
    }
    
    
  //MARK: Load data from core data
    static func loadData<T:NSFetchRequestResult>(entityName:String, predicate:NSPredicate?, sortDescriptor:NSSortDescriptor? = nil) -> [T] {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: CoreDataStore.managedObjectContext) else {
            return [T]()
        }
        
        let request = NSFetchRequest<T>()
        if predicate != nil {
            request.predicate = predicate
        }
        if let sort = sortDescriptor {
            request.sortDescriptors = [sort]
        }
        request.entity = entityDescription
        
        do {
            let results = try CoreDataStore.managedObjectContext.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
            return [T]()
        }
    }
    
    static func clearAllData(entityName:String){
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try persistentStoreCoordinator.execute(deleteRequest, with: managedObjectContext)
        } catch _ as NSError {
            print("Unable to delete" + entityName)
        }
    }
    private func clearAll() {
        if let entities = self.entities {

            for entity in entities {
                 // Log.info?.message("\(#function):Delete data from \(entity)")
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    let result = try CoreDataStore.managedObjectContext.execute(deleteRequest)
                    
                    print(result)
                    

                     // Log.info?.message("\(#function):\(result.description)")
                } catch {
                    print(error.localizedDescription)
                     // Log.error?.message("\(#function):Error:\(error.localizedDescription)")
                }
                
                
                
              
                
                
            }
            CoreDataStore.saveContext()

        } else {
             // Log.error?.message("\(#function):Data is already cleaned up!")
        }
    }

    
}
