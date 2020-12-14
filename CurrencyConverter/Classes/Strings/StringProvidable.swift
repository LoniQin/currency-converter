//
//  StringProvidable.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/14.
//

import Foundation
protocol StringProvidable {
    
    func networkError() -> String
    
    func retry() -> String
    
    func cancel() -> String
    
    func currencyConvertionTitle() -> String
    
    func currencyConvertionInputAmountHint() -> String
    
}

struct StringProvider: StringProvidable {
    
    func networkError() -> String {
        LocalizationKey.networkError.localizedString()
    }
    
    func cancel() -> String {
        LocalizationKey.cancel.localizedString()
    }
    
    func retry() -> String {
        LocalizationKey.retry.localizedString()
    }
    
    func currencyConvertionTitle() -> String {
        LocalizationKey.currencyConvertionTitle.localizedString()
    }
    
    func currencyConvertionInputAmountHint() -> String {
        LocalizationKey.currencyConvertionTitle.localizedString()
    }
}
