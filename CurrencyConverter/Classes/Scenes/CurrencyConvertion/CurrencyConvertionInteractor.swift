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
}

class CurrencyConvertionInteractor: CurrencyConvertionBusinessLogic {
    
    let configuration: CurrencyConvertionConfiguration
    
    let repository: CurrencyRepositoryProtocol
    
    public init(configuration: CurrencyConvertionConfiguration, repository: CurrencyRepositoryProtocol) {
        self.configuration = configuration
        self.repository = repository
    }
    
    var presenter: CurrencyConvertionPresentationLogic?
    
    func requestSetupView(request: CurrencyConvertion.SetupViewRequest) {
        presenter?.presentSetupView(response: .init())
        repository.getCurrencyList { (result) in
            switch result {
            case .success(let list):
                print(list)
            case .failure(let error):
                print(error)
            }
        }
        repository.getExchangeRates { (result) in
            switch result {
            case .success(let list):
                print(list)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getCurrencyList() {
        
    }
    
    func getQuoteList() {
        
    }
    
}
