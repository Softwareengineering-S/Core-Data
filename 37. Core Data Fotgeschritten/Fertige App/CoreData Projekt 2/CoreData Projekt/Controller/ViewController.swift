//
//  ViewController.swift
//  CoreData Projekt
//
//  Created by Christian on 15.10.18.
//  Copyright © 2018 codingenieur. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    
    var usersArray = [User]()
    
    var selectedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.rowHeight = 80
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        print("viewDidLoad")
        
        loadData()
    }

    
    @IBAction func createButton_Tapped(_ sender: UIBarButtonItem) {
        createUser()
    }
    
    
    @IBAction func deleteButton_Tapped(_ sender: UIBarButtonItem) {
        CoreDataService.defaults.cleanCoreDataStack()
        userTableView.reloadData()
    }
    
    
    @IBAction func refreshButton_Tapped(_ sender: UIBarButtonItem) {
        loadData()
    }
    
    // MARK: - Methoden
    func createUser() {
        let alert = UIAlertController(title: "Add User", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Alter"
            textField.keyboardType = .numberPad
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Straße"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Stadt"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "PLZ"
            textField.keyboardType = .numberPad
        }
        
      // Action, welche ausgeführt wird sobald auf OK gedrückt wird
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            if alert.textFields?[0].text?.count != 0  &&  alert.textFields?[1].text?.count != 0 &&  alert.textFields?[2].text?.count != 0 &&  alert.textFields?[3].text?.count != 0 &&  alert.textFields?[4].text?.count != 0 {
                let name = alert.textFields?[0].text
                let alter = Int16((alert.textFields?[1].text)!)
                let street = alert.textFields?[2].text
                let city = alert.textFields?[3].text
                let plz = Int32((alert.textFields?[4].text)!)
                
//                print(alert.textFields?[0].text! , alert.textFields?[1].text!, alert.textFields?[2].text!, alert.textFields?[3].text!,alert.textFields?[4].text!)
                
                // CoreData
                let information = CoreDataService.defaults.createInformation(_street: street!, _city: city!, _plz: plz!)
                let user = CoreDataService.defaults.createUser(_name: name!, _alter: alter!, _information: information)
                
                // Array
                self.usersArray.append(user)
                self.userTableView.reloadData()
                
            } else {
                self.errorMessage(_message: "Bitte Daten angeben")
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadData() {
        let userArray = CoreDataService.defaults.loadData()
        
        if let _userArray = userArray {
            self.usersArray = _userArray
            self.userTableView.reloadData()
        }
    }
    
    
    func errorMessage(_message: String) {
        let alert = UIAlertController(title: "Fehler", message: _message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func longPress(_ sender: UIGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            let longPressLocationPoint = sender.location(in: self.userTableView)
            
            if let pressIndexPath = self.userTableView.indexPathForRow(at: longPressLocationPoint) {
                
                var task = UITextField()
                
                let alert = UIAlertController(title: "Änderung", message: "Neue Daten eingeben", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                    self.usersArray[pressIndexPath.row].alter = Int16(task.text!)!
                    self.userTableView.reloadData()
                    CoreDataService.defaults.saveContext()
                }
                
                alert.addTextField { (textField) in
                    textField.placeholder = "Neues Alter"
                    textField.keyboardType = .numberPad
                    task = textField
                }
                
                let cancelAction = UIAlertAction(title: "Abrechen", style: .default) { (_) in }
                
                alert.addAction(action)
                alert.addAction(cancelAction)
                
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // goToShowUserInformationSegue
        if segue.identifier == "goToShowUserInformationSegue" {
            let destVC = segue.destination as! UserInformationViewController
            destVC.user = selectedUser
        }
    }
}



// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_ :)))
        cell.addGestureRecognizer(longPressRecognizer)
        
        let user = usersArray[indexPath.row]
        
        cell.textLabel?.text = "Name: \(user.name!) Alter: \(user.alter)"
        
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataService.defaults.deleteUserFromDataStack(indexPath: indexPath, userArray: &usersArray)
            userTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Zeile: ", indexPath.row)
        
        selectedUser = usersArray[indexPath.row]
        
        performSegue(withIdentifier: "goToShowUserInformationSegue", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



