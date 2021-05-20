//
//  UserTableViewController.swift
//  CoreData_Einführung
//
//  Created by Christian on 08.12.17.
//  Copyright © 2017 Christian. All rights reserved.
//

import UIKit
import CoreData

class UserTableViewController: UITableViewController {
    
    // Context wo sich die Daten / Objekte befinden
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Ein Array zum zwischenspeichern der Daten / Obejkte aus dem context
    var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //
    ///
    //// TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
     
     // Configure the cell...
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.password
     
     return cell
     }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteUser(indexPath: indexPath)
        }
        
    }
    
    
    //
    ///
    //// Actions
    
    @IBAction func createUsers(_ sender: UIBarButtonItem) {
        
        createUser(name: "Peter", password: "ewsdf", alter: 90)
        createUser(name: "Hans", password: "gfdhgfh", alter: 50)
        createUser(name: "Lukas", password: "234324", alter: 20)
        createUser(name: "Daniel", password: "ew5647sdf", alter: 15)
        
        print("User erstellt")
        
    }
    
    @IBAction func loadUsers(_ sender: UIBarButtonItem) {
        
        if let userArray = loadData() {
            self.users = userArray
            print("Geladen")
        }
    }
    
    
    @IBOutlet weak var cleanButtonTapped: UIBarButtonItem!
    
    
//    @IBAction func cleanButtonTapped(_ sender: UIBarButtonItem) {
//
//        cleanCoreDataStack()
//    }
    
    //
    ///
    //// CoreData
    
    // Daten einfügen / User Object erstellen
    func createUser(name: String, password: String, alter: Int) {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(name, forKey: "name")
        managedObject.setValue(password, forKey: "password")
        managedObject.setValue(alter, forKey: "alter")
    
        saveContext()
        
    }
    
    // Daten laden / Erhalten ein Array zurück
    func loadData() -> [User]? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let resultArray = try context.fetch(fetchRequest)
            return resultArray
        } catch  {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    // Eintrag löschen
    func deleteUser(indexPath: IndexPath) {
        
         // Aus dem Context löschen
        context.delete(users[indexPath.row])
        saveContext()
        
         // Aus dem Array löschen
        users.remove(at: indexPath.row)
    }
    
    // Speichern / Immer aufrufen sobald sich im context etwas verändert!
    func saveContext() {
        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    
    
    @IBAction func cleanButtonTapped(_ sender: UIBarButtonItem) {
        
        cleanCoreDataStack()
    }
    
    func cleanCoreDataStack() {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            
            print("Alles gelöscht")
        } catch {
            print ("There was an error")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
