//
//  AuthService.swift
//  NameSearch
//
//  Created by Noah Iarrobino on 5/2/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

struct AuthService {
    
    let validation = AuthenticationValidation()
    
    func tryLogin(request: URLRequest, username: String, password: String, handler: @escaping (_ error: Error?) -> ()){
        
        do {
            _ = try validation.validateUsername(username)
            _ = try validation.validatePassword(password)
            
            let session = URLSession(configuration: .default)
            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    handler(error)
                } else {
                    let authReponse = try! JSONDecoder().decode(LoginResponse.self, from: data!)

                    AuthManager.shared.user = authReponse.user
                    AuthManager.shared.token = authReponse.auth.token

                    handler(nil)
                }
            }.resume()
            
        } catch {
            handler(error)
        }
        
    }
}
