//
//  NetworkingService.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 20.01.2024.
//

import Foundation

enum MyResult<T, E: Error> {
    
    case success(T)
    case failure(E)
}

class NetworkingService {
    
    let baseUrl = "http://127.0.0.1:5000/api"
    
    func handleResponse(for request: URLRequest, 
                        completion: @escaping (Result<User, Error>) -> Void){
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                guard let unwrappedResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkingError.badResponse))
                    return
                }
                
                print(unwrappedResponse.statusCode)
                
                switch unwrappedResponse.statusCode {
                case 200 ..< 300:
                    print("success")
                default:
                    print("failure")
                }
                
                if let unwrappedError = error {
                    completion(.failure(unwrappedError))
                    return
                }
                
                if let unwrappedData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                        print(json)
                        print(type(of: json))
                        
                        if unwrappedResponse.statusCode == 200 {
                            let user = try JSONDecoder().decode(User.self, from: unwrappedData)
                            completion(.success(user))
                        } else {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: unwrappedData)
                            completion(.failure(errorResponse))
                        }
                        
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func handleResponseAccount(for request: URLRequest,
                        completion: @escaping (Result<AccountRecieved, Error>) -> Void){
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                guard let unwrappedResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkingError.badResponse))
                    return
                }
                
                print(unwrappedResponse.statusCode)
                
                switch unwrappedResponse.statusCode {
                case 200 ..< 300:
                    print("success")
                default:
                    print("failure")
                }
                
                if let unwrappedError = error {
                    completion(.failure(unwrappedError))
                    return
                }
                
                if let unwrappedData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                        print(json)
                        print(type(of: json))
                        
                        if unwrappedResponse.statusCode == 201 {
                            let account = try JSONDecoder().decode(AccountRecieved.self, from: unwrappedData)
                            completion(.success(account))
                        } else {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: unwrappedData)
                            completion(.failure(errorResponse))
                        }
                        
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func request(endpoint: String,
                 parameters: [String: Any],
                 method: String,
                 completion: @escaping (Result<User, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        
        var components = URLComponents()
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: String(describing: value))
            queryItems.append(queryItem)
        }
        
        components.queryItems = queryItems
        
        let queryItemData = components.query?.data(using: .utf8)
        
        request.httpBody = queryItemData
        request.httpMethod = method
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        handleResponse(for: request, completion: completion)
    }
    
    
    func request(endpoint: String,
                 loginObject: Login,
                 method: String,
                 completion: @escaping (Result<User, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        
        do {
            let loginData = try JSONEncoder().encode(loginObject)
            request.httpBody = loginData
        } catch {
            completion(.failure(NetworkingError.badEncoding))
        }
        
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        handleResponse(for: request, completion: completion)
    }
    
    func request(endpoint: String,
                 accountObject: AccountSend,
                 method: String,
                 completion: @escaping (Result<AccountRecieved, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        
        do {
            let accountData = try JSONEncoder().encode(accountObject)
            request.httpBody = accountData
        } catch {
            completion(.failure(NetworkingError.badEncoding))
        }
        
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        handleResponseAccount(for: request, completion: completion)
    }
    
}

enum NetworkingError: Error {
    case badUrl
    case badResponse
    case badEncoding
}
