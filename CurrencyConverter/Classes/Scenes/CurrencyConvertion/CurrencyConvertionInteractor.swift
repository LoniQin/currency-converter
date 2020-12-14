//
//  CurrencyConvertionInteractor.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/11.
//
import FoundationLib
import Foundation

protocol CurrencyConvertionBusinessLogic: AnyObject {
    
    func requestSetupView(request: CurrencyConvertion.SetupViewRequest)
    
    func requestLoading(request: CurrencyConvertion.LoadingRequest)
    
    func updateCurrency(request: CurrencyConvertion.UpdateCurrencyRequest)
    
}

class CurrencyConvertionInteractor: CurrencyConvertionBusinessLogic {
    
    var presenter: CurrencyConvertionPresentationLogic?
    
    let configuration: CurrencyConvertionConfiguration
    
    let repository: CurrencyRepositoryProtocol
    
    var currencyList: CurrencyList?
    
    var selectedIndex = 0
    
    var amount = "1.0"
    
    var quoteList: QuoteList?
    
    public init(configuration: CurrencyConvertionConfiguration, repository: CurrencyRepositoryProtocol) {
        self.configuration = configuration
        self.repository = repository
    }
    
    func requestSetupView(request: CurrencyConvertion.SetupViewRequest) {
        presenter?.presentSetupView(response: .init())
        getCurrencyListAndExchangeRates { [weak self] in
            if let self = self, let currencyList = self.currencyList {
                self.presenter?.presentCurrencyList(response: .init(
                    currencyList: currencyList
                ))
                self.presenter?.presentCurrency(
                    response:.init(
                        selectedIndex: self.selectedIndex,
                        currency: currencyList.currencies[self.selectedIndex]
                    )
                )
                self.presenter?.presentAmount(response: .init(amount: self.amount))
                self.calculateExchangeRates()
            }
        }
    }
    
    func requestLoading(request: CurrencyConvertion.LoadingRequest) {
        presenter?.presentLoading(response: .init(loading: request.loading))
    }
    
    func getCurrencyListAndExchangeRates(completion: @escaping ()->Void) {
        requestLoading(request: .init(loading: true))
        repository.getCurrencyList { [weak self] (result) in
            switch result {
            case .success(let currencyList):
                self?.currencyList = currencyList
                self?.getQuoteList(completion: completion)
            case .failure(let error):
                self?.requestLoading(request: .init(loading: false))
                self?.presenter?.presentError(
                    response: .init(
                        error: error,
                        retryBlock: {
                            self?.getCurrencyListAndExchangeRates(completion: completion)
                        }
                    )
                )
            }
        }
    }
    
    func getQuoteList(completion: @escaping ()->Void) {
        repository.getQuoteList { [ weak self] result in
            self?.requestLoading(request: .init(loading: false))
            switch result {
            case .success(let quoteList):
                self?.quoteList = quoteList
                completion()
            case .failure(let error):
                self?.presenter?.presentError(
                    response: .init(
                        error: error,
                        retryBlock: {
                            self?.getQuoteList(completion: completion)
                        }
                    )
                )
            }
        }
    }
    
    func calculateExchangeRates() {
        guard let currencyList = currencyList, let quoteList = quoteList, let amount = Double(amount) else {
            return
        }
        let currency = currencyList.currencies[selectedIndex].name
        let quoteDictionary = quoteList.quotes.reduce(into: [String: Double]()) { (result, quote) in
            result[quote.to] = quote.rate
        }
        let currencyQuote = quoteDictionary[currency].unwrapped
        let exchangeRates = currencyList.currencies.map {
            ExchangeRate(
                amount:  (quoteDictionary[$0.name].unwrapped / currencyQuote) * amount,
                currency: $0.name
            )
        }
        presenter?.presentExchangeRates(response: .init(exchangeRates: exchangeRates))
    }
    
    func updateCurrency(request: CurrencyConvertion.UpdateCurrencyRequest) {
        selectedIndex = request.selectedIndex
        requestLoading(request: .init(loading: true))
        getQuoteList { [weak self] in
            if let self = self, let currency = self.currencyList {
                self.presenter?.presentCurrency(
                    response: .init(
                        selectedIndex: self.selectedIndex,
                        currency: currency.currencies[self.selectedIndex]
                    )
                )
                self.calculateExchangeRates()
            }
        }
    }

}
