//
//  ErrorResponse.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 20.01.2024.
//

import Foundation

struct ErrorResponse: Decodable, LocalizedError {
    let message: String
    
    var errorDescription: String? { return message }
}
