//
//  CurrencyConvertionModels.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/11.
//

import Foundation
enum CurrencyConvertion {
    // Set up view
    struct SetupViewRequest {}
    struct SetupViewResponse {}
    struct SetupViewViewModel {
        let title: String
    }
    
    // Currency List
    struct CurrencyListRequest {
        
    }
    struct CurrencyListResponse {
        let currencyList: CurrencyList
    }
    struct CurrencyListViewModel {
        
    }
    
    // Update amount
    struct UpdateAmountRequest {}
    struct UpdateAmountResponse {}
    struct UpdateAmountViewModel {}
    
    // Choose Currency
    
    // Get Exchange rates
    
}
