//
//  Persistence.swift
//  AddaMeIOS
//
//  Created by Saroar Khandoker on 01.12.2020.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  static var moc: NSManagedObjectContext {
    return preview.container.viewContext
  }
  
  static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: false)
    let viewContext = result.container.viewContext
    viewContext.automaticallyMergesChangesFromParent = true
    viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    
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
  }
  
  func getRecordsCount(_ entityName: String) -> Int {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    do {
      let count = try PersistenceController.moc.count(for: fetchRequest)
      return count
    } catch {
      
      print(error.localizedDescription)
      return 0
    }
  }
  
  func getContacts() -> [ContactEntity] {
  
    let fetchRequest: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "isRegister == true")
    
    do {
      let results = try PersistenceController.moc.fetch(fetchRequest)
      return results
    } catch {
      print("failed to fetch record from CoreData")
      return []
    }
    
  }
  
}


