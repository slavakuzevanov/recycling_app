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
        emailTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: FormTextField) {
            if (textField.text!.isEmpty)
            {
                // change your textfield border color
                print("строка пустая")
                let color = UIColor(rgb: 0xe85e56).cgColor
                textField.layer.borderColor = color
                textField.layer.borderWidth = 1
                textField.layer.cornerRadius = 5
            }
            else
            {
                // remove text field border or change color
                print("строка не пустая")
                textField.layer.borderWidth = 0
            }
        }
    
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        
        print(email)
        print(password)
        
//        formDataRequest(email: email, password: password)
//        jsonRequest(email: email, password: password)
        
        if !email.isEmpty && !password.isEmpty {
            print("Выполняю jsonRequest")
            jsonRequest(email: email, password: password)
        } else {
            if email.isEmpty {
                let color = UIColor(rgb: 0xe85e56).cgColor
                emailTextField.layer.borderColor = color
                emailTextField.layer.borderWidth = 1
                emailTextField.layer.cornerRadius = 5
            } else {
                let color = UIColor(rgb: 0xe85e56).cgColor
                passwordTextField.layer.borderColor = color
                passwordTextField.layer.borderWidth = 1
                passwordTextField.layer.cornerRadius = 5
            }
        }
        
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
            print("jsonRequest result ", result)
            switch result {
            case .success(let user): 
                // Сохронение состояния логина
                UserDefaults.standard.hasLogged = true
                UserDefaults.standard.hasName = user.name
                UserDefaults.standard.hasId = user.user_id
                self?.performSegue(withIdentifier: "loginSeque", sender: user)
                
            case.failure(let error): 
                // Сохронение состояния логина
//                UserDefaults.standard.hasLogged = true
//                UserDefaults.standard.hasName = "Debug"
//                UserDefaults.standard.hasId = 0
//                print("Выполняется loginSeque")
//                self?.performSegue(withIdentifier: "loginSeque", sender: User(user_id: 0, name: "Debug"))
                guard let alert = self?.alertService.alert(message: error.localizedDescription) else {
                    return }
                self?.present(alert, animated: true)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainAppTB = segue.destination as? TabBarViewController, let user = sender as? User {
            mainAppTB.user = user
        }
    }
    
}
