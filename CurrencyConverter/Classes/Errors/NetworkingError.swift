//
//  NetworkError.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/13.
//

import Foundation

enum NetworkingError: Error {
    
    case serverError(_ error: ServerError)
    
    case unknownError(_ error: Error)
    
}
