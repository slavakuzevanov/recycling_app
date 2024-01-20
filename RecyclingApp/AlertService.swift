//
//  AllertService.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 20.01.2024.
//

import UIKit

class AlertService {
    
    func alert(message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        return alert
    }
}
