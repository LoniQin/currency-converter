//
//  CurrencyConvertionInteractor.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/11.
//

import Foundation

protocol CurrencyConvertionBusinessLogic: AnyObject {
    func requestSetupView(request: CurrencyConvertion.SetupViewRequest)
}

class CurrencyConvertionInteractor: CurrencyConvertionBusinessLogic {
    
    weak var presenter: CurrencyConvertionPresentationLogic?
    
    func requestSetupView(request: CurrencyConvertion.SetupViewRequest) {
        presenter?.presentSetupView(response: .init())
    }
    
}
