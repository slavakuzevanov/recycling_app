//
//  UserDefaults+Extension.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 18.05.2024.
//

import Foundation

extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case isLoggedIn
        case UserName
        case UserId
    }
    
    
    var hasLogged: Bool {
        get {
            bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        }
    }
    
    var hasName: String {
        get {
            string(forKey: UserDefaultsKeys.UserName.rawValue)!
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.UserName.rawValue)
        }
    }
    
    var hasId: Int {
        get {
            integer(forKey: UserDefaultsKeys.UserId.rawValue)
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.UserId.rawValue)
        }
    }
}
