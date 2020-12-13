//
//  StringProvidable.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/14.
//

import Foundation
protocol StringProvidable {
    
    func currencyConvertionTitle() -> String
    
}

struct StringProvider: StringProvidable {
    
    func currencyConvertionTitle() -> String {
        LocalizationKey.currencyConvertionTitle.localizedString()
    }
}
