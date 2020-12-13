//
//  Quote.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/14.
//

import Foundation

struct Quote: Codable {
    
    let from: String
    
    let to: String
    
    let rate: Double
    
}
