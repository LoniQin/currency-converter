//
//  CurrencyConvertionPresenter.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/11.
//

import Foundation
protocol CurrencyConvertionPresentationLogic: AnyObject {
    func presentSetupView(response: CurrencyConvertion.SetupViewResponse)
}

class CurrencyConvertionPresenter: CurrencyConvertionPresentationLogic {
    
    let configuration: CurrencyConvertionConfiguration
    
    init(configuration: CurrencyConvertionConfiguration) {
        self.configuration = configuration
    }

    weak var viewController: CurrencyConvertionDisplayLogic?
    
    weak var router: CurrencyConvertionRoutingLogic?
    
    func presentSetupView(response: CurrencyConvertion.SetupViewResponse) {
        viewController?.displaySetupView(
            viewModel: .init(
                title: configuration.stringProvider.currencyConvertionTitle()
            )
        )
    }
    
}
