//
//  MainAppViewController.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 20.01.2024.
//

import UIKit

class MainAppViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    
    var user: User?
    var account: AccountRecieved?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = user?.name {
            
            label.text = "Welcome, \(name.capitalized)"
        }
        if let name = account?.name {
            
            label.text = "Welcome, \(name.capitalized)"
        }
    }
}
