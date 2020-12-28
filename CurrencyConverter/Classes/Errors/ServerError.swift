//
//  ServerError.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/13.
//

import Foundation

struct ServerError: Error {
    
    let code: Int
    
    let info: String
    
}
