//
//  DictionayExtensions.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/13.
//
import FoundationLib
import Foundation
extension Dictionary: ResponseConvertable where Key == String, Value == Any {
    
    public static func toResponse(with data: Data) throws -> Dictionary<String, Any> {
        if let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
            return dictionary
        }
        throw FoundationError.invalidCoding
    }
    
}
