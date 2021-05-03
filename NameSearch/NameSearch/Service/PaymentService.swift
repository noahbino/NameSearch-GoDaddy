//
//  PaymentService.swift
//  NameSearch
//
//  Created by Noah Iarrobino on 5/2/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

struct PaymentService {
    
    let validation = PaymentValidation()
    
    func tryPurchase(request: URLRequest, paymentMethod: PaymentMethod, handler: @escaping (_ error: Error?) -> ()){
        
        do {
            _ = try validation.validatePurchaseRequest(request: request)
            
            let session = URLSession(configuration: .default)
            session.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    handler(error)
                } else {
                    handler(nil)
                }
                
            }.resume()
            
            
        } catch {
            handler(error)
        }
    }
    
    func paymentMethodRequest(request: URLRequest, handler: @escaping (_ methods: [PaymentMethod]?) -> ()){
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                handler(nil)
            }

            let methods = try! JSONDecoder().decode([PaymentMethod].self, from: data!)
            handler(methods)

        }.resume()
        
    }
    
    
    
}




