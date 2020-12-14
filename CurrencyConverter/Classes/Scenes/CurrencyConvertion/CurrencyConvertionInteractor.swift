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
}

class CurrencyConvertionInteractor: CurrencyConvertionBusinessLogic {
    
    var presenter: CurrencyConvertionPresentationLogic?
    
    let configuration: CurrencyConvertionConfiguration
    
    let repository: CurrencyRepositoryProtocol
    
    var currencyList: CurrencyList?
    
    var selectedIndex = 0
    
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
                    selectedIndex: self.selectedIndex, currencyList: currencyList
                ))
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
                self?.repository.getExchangeRates { result in
                    self?.requestLoading(request: .init(loading: false))
                    switch result {
                    case .success(let quoteList):
                        self?.quoteList = quoteList
                        completion()
                    case .failure(let error):
                        self?.presenter?.presentError(response: .init(error: error, retryBlock: {
                            self?.getCurrencyListAndExchangeRates(completion: completion)
                        }))
                    }
                }
            case .failure(let error):
                self?.requestLoading(request: .init(loading: false))
                self?.presenter?.presentError(response: .init(error: error, retryBlock: {
                    self?.getCurrencyListAndExchangeRates(completion: completion)
                }))
            }
        }
    }

}
