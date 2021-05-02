//
//  PaymentService.swift
//  NameSearch
//
//  Created by Noah Iarrobino on 5/2/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

struct PaymentService {
    
    func tryPurchase(request: URLRequest, paymentMethod: PaymentMethod, handler: @escaping (_ error: Error?) -> ()){
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                handler(error)
            } else {
                handler(nil)
            }
            
        }.resume()
    }
    
    
}




