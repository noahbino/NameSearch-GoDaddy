//
//  PaymentValidation.swift
//  NameSearch
//
//  Created by Noah Iarrobino on 5/2/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

struct PaymentValidation {
    func validatePurchaseRequest(request: URLRequest?) throws -> URLRequest {
        guard let request = request else {throw PurchaseError.invalid}
        let dict = try! JSONDecoder().decode([String:String].self, from: request.httpBody!)
        
        if request.httpMethod != "POST" {
            throw PurchaseError.isNotPOST
        }
        
        guard dict["auth"] != nil else {throw PurchaseError.invalidAuthToken}
        guard dict["token"] != nil else {throw PurchaseError.invalidPaymentToken}
        
        return request
    }
}

enum PurchaseError: LocalizedError {
    case isNotPOST
    case invalidAuthToken
    case invalidPaymentToken
    case invalid
    
    var errorDescription: String? {
        switch self {
        case .isNotPOST:
            return "This request should be of type POST"
        case .invalidAuthToken:
            return "Invalid auth token"
        case .invalidPaymentToken:
            return "Invalid payment token"
        case .invalid:
            return "Invalid"
        }
    }
}
