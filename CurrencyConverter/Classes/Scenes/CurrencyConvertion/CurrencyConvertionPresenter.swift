//
//  CurrencyConvertionPresenter.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/11.
//
import Foundation
protocol CurrencyConvertionPresentationLogic: AnyObject {
    func presentSetupView(response: CurrencyConvertion.SetupViewResponse)
    func presentLoading(response: CurrencyConvertion.LoadingResponse)
    func presentError(response: CurrencyConvertion.ErrorResponse)
    func presentCurrencyList(response: CurrencyConvertion.CurrencyListResponse)
}

class CurrencyConvertionPresenter: CurrencyConvertionPresentationLogic {
    
    weak var viewController: CurrencyConvertionDisplayLogic?
    
    var router: CurrencyConvertionRoutingLogic?
    
    let configuration: CurrencyConvertionConfiguration
    
    init(configuration: CurrencyConvertionConfiguration) {
        self.configuration = configuration
    }
    
    func presentSetupView(response: CurrencyConvertion.SetupViewResponse) {
        viewController?.displaySetupView(
            viewModel: .init(
                title: configuration.stringProvider.currencyConvertionTitle(),
                amountHint: configuration.stringProvider.currencyConvertionInputAmountHint()
            )
        )
    }
    
    func presentLoading(response: CurrencyConvertion.LoadingResponse) {
        viewController?.displayLoading(viewModel: .init(isAnimating: response.loading))
    }
    
    func presentError(response: CurrencyConvertion.ErrorResponse) {
        
        let viewModel = CurrencyConvertion.ErrorViewModel(
            title: configuration.stringProvider.networkError(),
            comfirmTitle: configuration.stringProvider.retry(),
            cancelTitle: configuration.stringProvider.cancel(),
            retryBlock: response.retryBlock
        )
        router?.routeToError(viewModel: viewModel)
    }
    
    func presentCurrencyList(response: CurrencyConvertion.CurrencyListResponse) {
        let currencies = response.currencyList.currencies.map { "\($0.name)(\($0.detail))" }
        viewController?.displayCurrencyList(
            viewModel: .init(
                selectedIndex: response.selectedIndex,
                currencies: currencies,
                currentCurrencyName: response.currencyList.currencies[response.selectedIndex].name
            )
        )
    }
    
    
}
