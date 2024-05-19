//
//  UINavViewController.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 18.05.2024.
//

import UIKit

class UINavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    static func instantiate() -> UINavViewController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // замените "Main" на имя вашего storyboard
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "InitialViewController") as? UINavViewController else {
                fatalError("Unable to instantiate InitialViewController from the storyboard")
            }
            return viewController
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
