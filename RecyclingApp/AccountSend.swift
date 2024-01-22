//
//  Account.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 21.01.2024.
//

import Foundation


struct AccountSend: Encodable, Decodable {
    let email: String
    let name: String
    let password: String
}
