//
//  CurrencyConvertionConfiguration.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/13.
//
import FoundationLib
import Foundation

struct CurrencyConvertionConfiguration {
    
    let httpClient: Networking
    
    let storage: DataStorage
    
    let stringProvider: StringProvidable
    
}
