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
        
        let amountHint: String
        
    }
    
    // Currency List
    struct CurrencyListRequest {}
    
    struct CurrencyListResponse {
        
        let currencyList: CurrencyList
        
    }
    
    struct CurrencyListViewModel {
        
        let selectedIndex: Int = 0
        
        let currencies: [String]
        
    }
    
    // Update amount
    struct UpdateAmountRequest {}
    
    struct UpdateAmountResponse {}
    
    struct UpdateAmountViewModel {}
    
    // Choose Currency
    
    // Get Exchange rates
    
    // Loading
    struct LoadingRequest {
        
        let loading: Bool
        
    }
    
    struct LoadingResponse {
        
        let loading: Bool
        
    }
    
    struct LoadingViewModel {
        
        let isAnimating: Bool
        
    }
    
    // Network Error
    struct ErrorResponse {
        
        let error: NetworkingError
        
        let retryBlock: ()->Void
        
    }
    
    struct ErrorViewModel {
    
        let title: String
        
        let comfirmTitle: String
        
        let cancelTitle: String
        
        let retryBlock: ()->Void
        
    }
}
