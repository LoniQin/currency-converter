//
//  NetworkManager.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/13.
//
import FoundationLib
import Foundation
protocol CurrencyRepositoryProtocol {
    func getCurrencyList(completion: @escaping (Result<CurrencyList, NetworkingError>)->Void) -> URLSessionTaskProtocol?
    
}
class CurrencyRepository {
    
    let httpClient: Networking
    
    public init(httpClient: Networking) {
        self.httpClient = httpClient
    }
    
    private func baseURL() -> String {
        "https://api.currencylayer.com"
    }
    
    private func accessKey() -> String {
        "9cf6f6e6012a36183aed686b3b93290c"
    }
    
    func getCurrencyList(completion: @escaping (Result<CurrencyList, NetworkingError>)->Void) -> URLSessionTaskProtocol? {
        let request = HttpRequest(
            domain: baseURL(),
            paths: ["list"],
            method: .get,
            query: HTTP.query(access_key: accessKey())
        )
        return get(request: request) { (result) in
            switch result {
            case .success(let diciontary):
                do {
                    let currencies: [String: String] = try diciontary.get("currencies")
                    completion(.success(CurrencyList(currencies)))
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
                let succeed: Bool = try dictionary.get("success")
                if succeed {
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
