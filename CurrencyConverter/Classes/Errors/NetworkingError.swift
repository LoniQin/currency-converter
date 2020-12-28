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
    
    init(_ error: Error) {
        if let error = error as? ServerError {
            self = .serverError(error)
        } else {
            switch error {
            case NetworkingError.serverError(let error):
                self = .serverError(error)
            case NetworkingError.unknownError(let error):
                self = .unknownError(error)
            default:
                self = .unknownError(error)
            }
        }

    }
    
}
