//
//  CurrencyConvertionInteractor.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/11.
//
import FoundationLib
import Foundation

protocol CurrencyConvertionBusinessLogic: AnyObject {
    
    func refreshData(request: CurrencyConvertion.RefreshDataRequest)
    
    func requestSetupView(request: CurrencyConvertion.SetupViewRequest)
    
    func requestLoading(request: CurrencyConvertion.LoadingRequest)
    
    func updateAmount(request: CurrencyConvertion.UpdateAmountRequest)
    
    func updateCurrency(request: CurrencyConvertion.UpdateCurrencyRequest)
    
    func requestExchangeRates(request: CurrencyConvertion.ExchangeRatesRequest)
    
}

class CurrencyConvertionInteractor: CurrencyConvertionBusinessLogic {
    
    struct Constants {
        static let defaultAmount = "1.0"
    }
    
    var presenter: CurrencyConvertionPresentationLogic?
    
    let configuration: CurrencyConvertionConfiguration
    
    let repository: CurrencyRepositoryProtocol
    
    var currencyList: CurrencyList?
    
    var selectedIndex = 0
    
    var amount = Constants.defaultAmount
    
    var quoteList: QuoteList?
    
    public init(configuration: CurrencyConvertionConfiguration, repository: CurrencyRepositoryProtocol) {
        self.configuration = configuration
        self.repository = repository
    }
    
    func requestSetupView(request: CurrencyConvertion.SetupViewRequest) {
        presenter?.presentSetupView(response: .init())
    }
    
    func refreshData(request: CurrencyConvertion.RefreshDataRequest) {
        getCurrencyListAndExchangeRates { [weak self] in
            guard let self = self, let currencyList = self.currencyList else { return }
            self.presenter?.presentCurrencyList(
                response: .init(
                    currencyList: currencyList
                )
            )
            self.presenter?.presentCurrency(
                response:.init(
                    selectedIndex: self.selectedIndex,
                    currency: currencyList.currencies[self.selectedIndex]
                )
            )
            self.presenter?.presentAmount(response: .init(amount: self.amount))
            self.requestExchangeRates(request: .init())
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
    
    func requestExchangeRates(request: CurrencyConvertion.ExchangeRatesRequest) {
        guard let currencyList = currencyList, let quoteList = quoteList, let amount = Double(amount) else {
            return
        }
        let currency = currencyList.currencies[selectedIndex].name
        let quoteDictionary = quoteList.quotes.reduce(into: [String: Double]()) { (result, quote) in
            result[quote.to] = quote.rate
        }
        let currencyQuote = quoteDictionary[currency].unwrapped
        guard currencyQuote > 0 else { return }
        let exchangeRates = currencyList.currencies.map {
            ExchangeRate(
                amount:  (quoteDictionary[$0.name].unwrapped / currencyQuote) * amount,
                currency: $0.name
            )
        }
        presenter?.presentExchangeRates(response: .init(exchangeRates: exchangeRates))
    }
    
    func updateAmount(request: CurrencyConvertion.UpdateAmountRequest) {
        if Double(request.amount) != nil || request.amount.isEmpty {
            self.amount = request.amount
        }
        self.presenter?.presentAmount(response: .init(amount: self.amount))
    }
    
    func updateCurrency(request: CurrencyConvertion.UpdateCurrencyRequest) {
        selectedIndex = request.selectedIndex
        requestLoading(request: .init(loading: true))
        getQuoteList { [weak self] in
            guard let self = self, let currency = self.currencyList else { return }
            self.presenter?.presentCurrency(
                response: .init(
                    selectedIndex: self.selectedIndex,
                    currency: currency.currencies[self.selectedIndex]
                )
            )
            self.requestExchangeRates(request: .init())
        }
    }

}
