//
//  MainAppViewController.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 20.01.2024.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    var user: User?
    var account: AccountRecieved?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Profile view ", user as Any)
        print("Profile view ", account as Any)
        
        if UserDefaults.standard.hasLogged {
            label.text = "Welcome, \(UserDefaults.standard.hasName!.capitalized)"
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
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        // Сброс состояния пользователя в UserDefaults
        UserDefaults.standard.hasLogged = false
        UserDefaults.standard.hasName = ""
        UserDefaults.standard.hasId = 0
        
        // Получите storyboard и initial view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let initialViewController = storyboard.instantiateInitialViewController() {
            // Замените root view controller окна
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = initialViewController
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    }
}
