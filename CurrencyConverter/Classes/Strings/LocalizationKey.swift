//
//  StringProvidable.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/14.
//
import Foundation
enum LocalizationKey: String {
    
    case networkError
    
    case retry
    
    case cancel
    
    case currencyConvertionTitle
    
    case currencyConvertionInputAmountHint
    
    func localizedString() -> String {
        var key = ""
        for char in rawValue {
            if char.isUppercase {
                key.append("_")
            }
            key.append(char.lowercased())
        }
        return NSLocalizedString(key, tableName: "currency_converter", comment: "")
    }
    
}
