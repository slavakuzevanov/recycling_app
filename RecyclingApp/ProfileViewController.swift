//
//  MainAppViewController.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 20.01.2024.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    
    var user: User?
    var account: AccountRecieved?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Profile view ", user as Any)
        print("Profile view ", account as Any)
        
        if UserDefaults.standard.hasLogged {
            label.text = "Welcome, \(UserDefaults.standard.hasName.capitalized)"
        } else {
            if let name = user?.name {
                print("View Controller user ", name)
                label.text = "Welcome, \(name.capitalized)"
            }
            if let name = account?.name {
                print("View Controller account ", name)
                label.text = "Welcome, \(name.capitalized)"
            }
        }

    }
}
