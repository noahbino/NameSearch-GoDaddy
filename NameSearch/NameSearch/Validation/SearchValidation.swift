//
//  SearchValidation.swift
//  NameSearch
//
//  Created by Noah Iarrobino on 5/2/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

struct SearchValidation {
    func validateSearchRequest(search: String?) throws -> String {
        guard let search = search else {throw SearchError.invalid}
        
        if search == "" {throw SearchError.emptySearch}
        
        return search
    }
}

enum SearchError: LocalizedError {
    case emptySearch
    case invalid
    
    var errorDescription: String? {
        switch self {
        case .emptySearch:
            return "Search cannot be empty"
        case .invalid:
            return "Search is invalid"
        }
    }
}
