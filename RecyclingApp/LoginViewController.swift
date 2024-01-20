//
//  LoginViewController.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 20.01.2024.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: FormTextField!
    @IBOutlet weak var passwordTextField: FormTextField!
    
    let alertService = AlertService()
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        
//        formDataRequest(email: email, password: password)
        jsonRequest(email: email, password: password)
        
    }
    
    func formDataRequest(email: String, password: String){
        let parameters = ["email": email,
                          "password": password]
        
        networkingService.request(endpoint: "/login", parameters: parameters, method: "POST") { [weak self] (result) in
            print(result)
            switch result {
            case .success(let user): self?.performSegue(withIdentifier: "loginSeque", sender: user)
                
            case.failure(let error):
                guard let alert = self?.alertService.alert(message: error.localizedDescription) else {
                    return }
                self?.present(alert, animated: true)
            }
        }
    }
    
    func jsonRequest(email: String, password: String){
        
        let login = Login(email: email, password: password)
        
        networkingService.request(endpoint: "/login", loginObject: login, method: "POST") { [weak self] (result) in
            switch result {
            case .success(let user): self?.performSegue(withIdentifier: "loginSeque", sender: user)
                
            case.failure(let error):
                guard let alert = self?.alertService.alert(message: error.localizedDescription) else {
                    return }
                self?.present(alert, animated: true)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainAppVC = segue.destination as? MainAppViewController, let user = sender as? User {
            mainAppVC.user = user
        }
    }
    
}
