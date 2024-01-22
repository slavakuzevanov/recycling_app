//
//  CreateAccountViewController.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 21.01.2024.
//

import UIKit

class CreateAccountViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: FormTextField!
    @IBOutlet weak var nameTextField: FormTextField!
    @IBOutlet weak var passwordTextField: FormTextField!
    @IBOutlet weak var passwordConfTextField: FormTextField!
    
    let alertService = AlertService()
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
        passwordConfTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
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
    
    
    
    @IBAction func didTapCreateAccountButton(_ sender: Any) {
        print("Нажал на создание аккаунта")
        guard
            let email = emailTextField.text,
            let name = nameTextField.text,
            let password = passwordTextField.text,
            let password_confirmation = passwordConfTextField.text
        else {return}
        
        if !email.isEmpty && !name.isEmpty && !password.isEmpty && !password_confirmation.isEmpty {
            if password == password_confirmation {
                jsonRequest(email: email, name: name, password: password)
            } else {
                let alert = alertService.alert(message: "Passwords do not match, please try again")
                let color = UIColor(rgb: 0xe85e56).cgColor
                passwordConfTextField.layer.borderColor = color
                passwordConfTextField.layer.borderWidth = 1
                passwordConfTextField.layer.cornerRadius = 5
                self.present(alert, animated: true)
            }
        } else {
            if email.isEmpty {
                let color = UIColor(rgb: 0xe85e56).cgColor
                emailTextField.layer.borderColor = color
                emailTextField.layer.borderWidth = 1
                emailTextField.layer.cornerRadius = 5
            }
            if name.isEmpty {
                let color = UIColor(rgb: 0xe85e56).cgColor
                nameTextField.layer.borderColor = color
                nameTextField.layer.borderWidth = 1
                nameTextField.layer.cornerRadius = 5
            }
            if password.isEmpty {
                let color = UIColor(rgb: 0xe85e56).cgColor
                passwordTextField.layer.borderColor = color
                passwordTextField.layer.borderWidth = 1
                passwordTextField.layer.cornerRadius = 5
            }
            if password_confirmation.isEmpty {
                let color = UIColor(rgb: 0xe85e56).cgColor
                passwordConfTextField.layer.borderColor = color
                passwordConfTextField.layer.borderWidth = 1
                passwordConfTextField.layer.cornerRadius = 5
            }
        }
    }
    
    func jsonRequest(email: String, name: String, password: String){
        
        let account = AccountSend(email: email, name: name, password: password)
        
        networkingService.request(endpoint: "/new_user", accountObject: account, method: "POST") { [weak self] (result) in
            switch result {
            case .success(let account): self?.performSegue(withIdentifier: "createAccountSeque", sender: account)
                
            case.failure(let error):
                guard let alert = self?.alertService.alert(message: error.localizedDescription) else {
                    return }
                self?.present(alert, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainAppVC = segue.destination as? MainAppViewController, let account = sender as? AccountRecieved {
            mainAppVC.account = account
        }
    }
    
}
