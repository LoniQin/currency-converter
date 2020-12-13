//
//  CurrencyList.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/13.
//
import Foundation
struct CurrencyList {
    
    let currencies: [Currency]
    
    init(_ dictionary: [String: String]) {
        currencies = dictionary.sorted { $0.0 < $1.0 }.map { Currency(name: $0.0, detail: $0.1) }
    }
    
}
