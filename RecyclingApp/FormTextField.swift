//
//  FormTextField.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 20.01.2024.
//

import UIKit

class FormTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor : UIColor(white: 1, alpha: 0.3)])
        
        let underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = .white
        
        addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            
            underlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            underlineView.heightAnchor.constraint(equalToConstant: 1)
            ])
    }
    
}
