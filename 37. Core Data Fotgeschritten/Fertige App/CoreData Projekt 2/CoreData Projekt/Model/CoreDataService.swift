//
//  CoreDataService.swift
//  CoreData Projekt
//
//  Created by Christian on 15.10.18.
//  Copyright © 2018 codingenieur. All rights reserved.
//

import Foundation
import CoreData


class CoreDataService {
    
    // MARK: - Singleton Pattern
    static let defaults = CoreDataService()
    
    // MARK: - Context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - init
    private init() { }
    
    
    // MARK: - PersistentContainer
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreData_Projekt")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - saveContext
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD - Create / Read / Update / Delete
    
    // Create
    func createUser(_name: String, _alter: Int16, _information: Information) -> User {
        let user = User(context: context)
        user.name = _name
        user.alter = _alter
        
        // Beziehung setzen
        user.information = _information
        
        saveContext()
        
        return user
    }
    
    // Create Information
    func createInformation(_street: String, _city: String, _plz: Int32) -> Information {
        let information = Information(context: context)
        information.street = _street
        information.city = _city
        information.plz = _plz
        
        saveContext()
        
        return information
    }
  
    // Read
    func loadData() -> [User]? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest() // Nur die Anfrage
        
        do {
            let resultArray = try context.fetch(fetchRequest)
            return resultArray
        } catch  {
            print("Fehler beim laden der Daten", error.localizedDescription)
        }
        
        return nil
    }
    
    // Update Data
    func updateUser(alter: Int16) {
        
    }
    
    // Delete All Stuff
    func cleanCoreDataStack() {
        let deleteFetchUser = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequestUser = NSBatchDeleteRequest(fetchRequest: deleteFetchUser)
        
        let deleteFetchInformation = NSFetchRequest<NSFetchRequestResult>(entityName: "Information")
        let deleteRequestInformation = NSBatchDeleteRequest(fetchRequest: deleteFetchInformation)
        
        do {
            try context.execute(deleteRequestUser)
             try context.execute(deleteRequestInformation)
            try context.save()
        } catch  {
            print("Fehler beim löschen", error.localizedDescription)
        }
    }
    
    // Delete one Stuff
    func deleteUserFromDataStack(indexPath: IndexPath, userArray: inout [User]) {
        // inout -> In Swift sind Parameter Standart Konstat. Wenn man einen Wert innerhalb der Methode verändern will dann inout nutzen!
        context.delete(userArray[indexPath.row])
        context.delete(userArray[indexPath.row].information!)
        userArray.remove(at: indexPath.row)
        saveContext()
    }
}
