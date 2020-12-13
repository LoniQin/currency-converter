//
//  CurrencyConvertionRouter.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/13.
//

import Foundation
protocol CurrencyConvertionRoutingLogic: AnyObject {
    func routeToCurrencyList()
}
class CurrencyConvertionRouter: CurrencyConvertionRoutingLogic {
    
    weak var viewController: CurrencyConvertionViewController?
    
    func routeToCurrencyList() {
        
    }
    
}
