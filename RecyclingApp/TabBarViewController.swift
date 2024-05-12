//
//  TabBarViewController.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 11.05.2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    var user: User?
    var account: AccountRecieved?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = user?.name {
            print("user ", name)
//            label.text = "Welcome, \(name.capitalized)"
        }
        if let name = account?.name {
            print("account ", name)
//            label.text = "Welcome, \(name.capitalized)"
        }
        
        print("код здесь")
        // Здесь прямо получаю view controller, который является первым ребенком navigation controller'a (0 view controller таб бара)
        let profileVC = self.viewControllers![0].children[0] as! ProfileViewController
        profileVC.user = user
        profileVC.account = account
    }
}
