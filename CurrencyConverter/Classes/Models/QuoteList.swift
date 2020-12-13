//
//  QuoteList.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/14.
//

import Foundation
struct QuoteList: Codable {
    
    let quotes: [Quote]
    
    let created: Date
    
    init(_ dictionary: [String: Double], source: String) {
        quotes = dictionary
            .sorted { $0.0 < $1.0 }
            .map { Quote(from: source, to: $0.0.replacingOccurrences(of: source, with: ""), rate: $0.1) }
        created = Date()
    }
}
