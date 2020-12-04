//
//  Persistence.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 01.12.2020.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  public var moc: NSManagedObjectContext {
    return container.viewContext
  }
  
  static public var preview: PersistenceController = {
    let result = PersistenceController(inMemory: false)
    let viewContext = result.container.viewContext
    
    if viewContext.hasChanges {
      do {
        try viewContext.save()
      } catch {
        // The context couldn't be saved.
        // You should add your own error handling here.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
    
    return result
    
  }()
  
  let container: NSPersistentContainer
  
  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "AddaModel")
    
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
  }
  
  // MARK: - Core Data Saving support
  public func saveContext () {
    let context = container.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
}
