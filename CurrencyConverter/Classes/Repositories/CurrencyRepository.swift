//
//  NetworkManager.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/13.
//
import FoundationLib
import Foundation
protocol CurrencyRepositoryProtocol {
    
    func getCurrencyList(completion: @escaping (Result<CurrencyList, NetworkingError>)->Void)
    
    func getExchangeRates(completion: @escaping (Result<QuoteList, NetworkingError>)->Void)
    
}
class CurrencyRepository: CurrencyRepositoryProtocol {
    
    let httpClient: Networking
    
    let storage: DataStorage
    
    public init(httpClient: Networking, storage: DataStorage) {
        self.httpClient = httpClient
        self.storage = storage
    }
    
    private func baseURL() -> String {
        "http://api.currencylayer.com"
    }
    
    private func accessKey() -> String {
        "9cf6f6e6012a36183aed686b3b93290c"
    }
    
    func getCurrencyList(completion: @escaping (Result<CurrencyList, NetworkingError>)->Void) {
        let key = "currency_list"
        if let currencyList: CurrencyList = try? storage.get(key) {
            completion(.success(currencyList))
            return
        }
        let request = HttpRequest(
            domain: baseURL(),
            paths: ["list"],
            method: .get,
            query: HTTP.query(access_key: accessKey())
        )
        _ = get(request: request) { [weak self] (result) in
            switch result {
            case .success(let diciontary):
                do {
                    let currencies: [String: String] = try diciontary.get("currencies")
                    let currencyList = CurrencyList(currencies)
                    try self?.storage.set(currencyList, for: key)
                    try self?.storage.save()
                    completion(.success(currencyList))
                } catch let error {
                    completion(.failure(.unknownError(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getExchangeRates(completion: @escaping (Result<QuoteList, NetworkingError>)->Void) {
        let key = "exchange_rates"
        if let quoteList: QuoteList = try? storage.get(key), Date().timeIntervalSince(quoteList.created) < 30 * 60 {
            completion(.success(quoteList))
            return
        }
        let request = HttpRequest(
            domain: baseURL(),
            paths: ["live"],
            method: .get,
            query: HTTP.query(access_key: accessKey())
        )
        _ = get(request: request) { [weak self] (result) in
            switch result {
            case .success(let diciontary):
                do {
                    let source: String = try diciontary.get("source")
                    let quotes: [String: Double] = try diciontary.get("quotes")
                    let quoteList = QuoteList(quotes, source: source)
                    try self?.storage.set(quoteList, for: key)
                    try self?.storage.save()
                    completion(.success(quoteList))
                } catch let error {
                    completion(.failure(.unknownError(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func get(
        request: RequestConvertable,
        completion: @escaping (Result<[String: Any], NetworkingError>) -> Void
    ) -> URLSessionTaskProtocol? {
        httpClient.send(request) { (result: Result<[String: Any], Error>) in
            do {
                let dictionary = try result.get()
                let success: Bool = try dictionary.get("success")
                if success {
                    completion(.success(dictionary))
                } else {
                    let error: [String: Any] = try dictionary.get("error")
                    let serverError = try ServerError(code: error.get("code"), info: error.get("info"))
                    completion(.failure(.serverError(serverError)))
                }
            } catch let error {
                completion(.failure(.unknownError(error)))
            }
        }
    }
    
}
