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
    }
    
    
    @IBAction func didTapCreateAccountButton(_ sender: Any) {
        print("Нажал на создание аккаунта")
        guard
            let email = emailTextField.text,
            let name = nameTextField.text,
            let password = passwordTextField.text,
            let password_confirmation = passwordConfTextField.text
        else {return}
        
        jsonRequest(email: email, name: name, password: password)
            
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
