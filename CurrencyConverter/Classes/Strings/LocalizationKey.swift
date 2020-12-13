//
//  StringProvidable.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/14.
//
import Foundation
enum LocalizationKey: String {
    
    case currencyConvertionTitle
    
    func localizedString() -> String {
        var key = ""
        for char in rawValue {
            if char.isUppercase {
                key.append("_")
            }
            key.append(char)
        }
        return NSLocalizedString(key, tableName: "currency_converter", comment: "")
    }
    
}
