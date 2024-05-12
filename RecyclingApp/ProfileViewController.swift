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
        
        print(user as Any)
        print(account as Any)

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
