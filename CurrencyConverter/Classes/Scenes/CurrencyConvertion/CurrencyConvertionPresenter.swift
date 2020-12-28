//
//  CurrencyConvertionPresenter.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/11.
//
import Foundation
import UIKit
protocol CurrencyConvertionPresentationLogic: AnyObject {
    
    func presentSetupView(response: CurrencyConvertion.SetupViewResponse)
    
    func presentLoading(response: CurrencyConvertion.LoadingResponse)
    
    func presentError(response: CurrencyConvertion.ErrorResponse)
    
    func presentCurrencyList(response: CurrencyConvertion.CurrencyListResponse)
    
    func presentAmount(response: CurrencyConvertion.UpdateAmountResponse)
    
    func presentExchangeRates(response: CurrencyConvertion.ExchangeRatesResponse)
    
    func presentCurrency(response: CurrencyConvertion.UpdateCurrencyResponse)
    
}

class CurrencyConvertionPresenter: CurrencyConvertionPresentationLogic {
    
    struct Constants {
        static let fractionDigitsCount = 4
    }
    
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
                amountHint: configuration.stringProvider.currencyConvertionInputAmountHint(),
                refreshImage: UIImage(named: "refresh")
            )
        )
    }
    
    func presentLoading(response: CurrencyConvertion.LoadingResponse) {
        viewController?.displayLoading(viewModel: .init(isAnimating: response.loading))
    }
    
    func presentError(response: CurrencyConvertion.ErrorResponse) {
        var actions = [UIAlertAction]()
        actions.append(.init(title: configuration.stringProvider.retry(), style: .default, handler: { (action) in
            response.retryBlock()
        }))
        actions.append(.init(title: configuration.stringProvider.cancel(), style: .cancel, handler: nil))
        let viewModel = CurrencyConvertion.ErrorViewModel(
            title: configuration.stringProvider.networkError(),
            actions: actions
        )
        router?.routeToError(viewModel: viewModel)
        viewController?.displayNoData(
            viewModel: .init(title: configuration.stringProvider.noData())
        )
    }
    
    func presentCurrencyList(response: CurrencyConvertion.CurrencyListResponse) {
        let currencies = response.currencyList.currencies.map { $0.name }
        viewController?.displayCurrencyList(
            viewModel: .init(
                currencies: currencies
            )
        )
    }
    
    func presentAmount(response: CurrencyConvertion.UpdateAmountResponse) {
        viewController?.displayAmount(
            viewModel: .init(amount: response.amount)
        )
    }
    
    func presentExchangeRates(response: CurrencyConvertion.ExchangeRatesResponse) {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = Constants.fractionDigitsCount
        formatter.maximumFractionDigits = Constants.fractionDigitsCount
        viewController?.displayExchangeRates(
            viewModel: .init(
                items: response.exchangeRates.map { "\(formatter.string(from: NSNumber(value: $0.amount)).unwrapped) \($0.currency)" }
            )
        )
    }
    
    func presentCurrency(response: CurrencyConvertion.UpdateCurrencyResponse) {
        viewController?.displayCurrency(
            viewModel: .init(
                selectedIndex: response.selectedIndex,
                currentCurrencyName: response.currency.name
            )
        )
    }
    
}
