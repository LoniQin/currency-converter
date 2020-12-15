//
//  CurrencyConvertionModels.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/11.
//

import Foundation

enum CurrencyConvertion {
    
    //MARK: Set up view
    
    struct SetupViewRequest {}
    
    struct SetupViewResponse {}
    
    struct SetupViewViewModel {
        
        let title: String
        
        let amountHint: String
        
    }
    
    //MARK: Refresh data
    
    struct RefreshDataRequest {}
    
    //MARK: Currency List
    
    struct CurrencyListRequest {}
    
    struct CurrencyListResponse {
        
        let currencyList: CurrencyList
        
    }
    
    struct CurrencyListViewModel {
        
        let currencies: [String]
        
    }
    
    //MARK: Update amount
    
    struct UpdateAmountRequest {
        
        let amount: String
        
    }
    
    struct UpdateAmountResponse {
        
        let amount: String
        
    }
    
    struct UpdateAmountViewModel {
        
        let amount: String
        
    }
    
    //MARK: Update Currency
    
    struct UpdateCurrencyRequest {
        
        let selectedIndex: Int
        
    }
    
    struct UpdateCurrencyResponse {
        
        let selectedIndex: Int
        
        let currency: Currency
        
    }
    
    struct UpdateCurrencyViewModel {
        
        let selectedIndex: Int
        let currentCurrencyName: String
    }
    
    //MARK: Exchange rates
    
    struct ExchangeRatesRequest {}
    
    struct ExchangeRatesResponse {
        
        var exchangeRates: [ExchangeRate]
        
    }
    
    struct ExchangeRatesViewModel {
        
        var items: [String]
        
    }
    
    //MARK: Loading
    
    struct LoadingRequest {
        
        let loading: Bool
        
    }
    
    struct LoadingResponse {
        
        let loading: Bool
        
    }
    
    struct LoadingViewModel {
        
        let isAnimating: Bool
        
    }
    
    //MARK: Error
    
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
    
    //MARK: No Data
    
    struct NoDataViewModel {
        
        let title: String
        
    }
}
