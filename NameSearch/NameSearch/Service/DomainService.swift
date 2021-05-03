//
//  DomainService.swift
//  NameSearch
//
//  Created by Noah Iarrobino on 5/2/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

struct DomainService {
    func loadDomains(request: URLRequest, suggestionRequest:URLRequest, handler: @escaping (_ domains: [Domain]?) -> ()){
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                handler(nil)
            }
            if let data = data {
                let exactMatchResponse = try! JSONDecoder().decode(DomainSearchExactMatchResponse.self, from: data)
                self.loadSuggestionDomains(exactMatchResponse: exactMatchResponse, session: session, request: suggestionRequest) { (domains) in
                    if let domains = domains {
                        handler(domains)
                    } else {
                        handler(nil)
                    }
                }
            }
        }.resume()
    }
    
    private func loadSuggestionDomains(exactMatchResponse: DomainSearchExactMatchResponse,session: URLSession, request: URLRequest, handler: @escaping (_ suggestionDomains: [Domain]?) -> ()){
        session.dataTask(with: request) { (suggestionsData, suggestionsResponse, error) in
            guard error == nil else { return }

            if let suggestionsData = suggestionsData {
                let suggestionsResponse = try! JSONDecoder().decode(DomainSearchRecommendedResponse.self, from: suggestionsData)

                let exactDomainPriceInfo = exactMatchResponse.products.first(where: { $0.productId == exactMatchResponse.domain.productId })!.priceInfo
                let exactDomain = Domain(name: exactMatchResponse.domain.fqdn,
                                         price: exactDomainPriceInfo.currentPriceDisplay,
                                         productId: exactMatchResponse.domain.productId)

                let suggestionDomains = suggestionsResponse.domains.map { domain -> Domain in
                    let priceInfo = suggestionsResponse.products.first(where: { price in
                        price.productId == domain.productId
                    })!.priceInfo

                    return Domain(name: domain.fqdn, price: priceInfo.currentPriceDisplay, productId: domain.productId)
                }

                handler(suggestionDomains + [exactDomain])
            }
        }.resume()
    }
}
