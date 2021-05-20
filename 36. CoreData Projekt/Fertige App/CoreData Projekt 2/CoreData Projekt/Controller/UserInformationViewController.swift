//
//  UserInformationViewController.swift
//  CoreData Projekt
//
//  Created by Christian on 17.10.18.
//  Copyright © 2018 codingenieur. All rights reserved.
//

import UIKit

class UserInformationViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showUserInfo(user: user)
    }
    
    func showUserInfo(user: User?) {
        if let _user = user {
            infoLabel.text = "Name: \(_user.name!) \n" +
            "Alter: \(_user.alter) \n" +
            "Straße: \(_user.information!.street!) \n" +
            "Stadt: \(_user.information!.city!) \n" +
            "PLZ: \(_user.information!.plz)"
        }
    }
}

