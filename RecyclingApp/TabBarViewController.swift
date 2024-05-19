//
//  TabBarViewController.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 11.05.2024.
//

import UIKit
import SwiftUI

class TabBarViewController: UITabBarController {

    var user: User?
    var account: AccountRecieved?
    private var customTabBarView: UIHostingController<CustomTabBar>?
    private var tabBarState = TabBarState()
    weak var customdelegate: TabBarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true

        if let name = user?.name {
            print("user ", name)
//            label.text = "Welcome, \(name.capitalized)"
//            label.text = "Welcome, \(name.capitalized)"
        }
        if let name = account?.name {
            print("account ", name)
//            label.text = "Welcome, \(name.capitalized)"
        }
        
        print("TabBarViewController код здесь")
        print("UserId: ", UserDefaults.standard.integer(forKey: "UserId"))
        print("UserName: ", UserDefaults.standard.string(forKey: "UserName")!)
        // Здесь прямо получаю view controller, который является первым ребенком navigation controller'a (0 view controller таб бара)
        let profileVC = self.viewControllers![0].children[0] as! ProfileViewController
        profileVC.user = user
        profileVC.account = account
        
        setupCustomTabBar()
        
        customTabBarView?.rootView.onTabSelected = { [weak self] selectedTab in
                    self?.handleTabSelection(selectedTab)
                }
    }
    
    static func instantiate() -> TabBarViewController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // замените "Main" на имя вашего storyboard
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else {
                fatalError("Unable to instantiate TabBarViewController from the storyboard")
            }
            return viewController
        }
    
    private func setupCustomTabBar() {
        // Скрываем стандартный таб-бар
        tabBar.isHidden = true
            
        // Создаем и добавляем кастомный таб-бар
        let customTabBarView = UIHostingController(rootView: CustomTabBar(tabBarState: tabBarState)) // Передайте ссылку на self
        addChild(customTabBarView)
        
        customTabBarView.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customTabBarView.view)
        customTabBarView.view.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            customTabBarView.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            customTabBarView.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            customTabBarView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            customTabBarView.view.heightAnchor.constraint(equalToConstant: 50) // Установите высоту по вашему усмотрению
        ])
        
        customTabBarView.didMove(toParent: self)
        self.customTabBarView = customTabBarView
    }
    
    func handleTabSelection(_ selectedTab: String) {
        switch selectedTab {
        case "house.fill":
            selectedIndex = 0
        case "camera.viewfinder":
            selectedIndex = 1
        case "map.fill":
            selectedIndex = 2
        default:
            selectedIndex = 0
        }
    }
}
