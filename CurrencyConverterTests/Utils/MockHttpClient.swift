//
//  MockHttpClient.swift
//  CurrencyConverterTests
//
//  Created by Lonnie on 2020/12/14.
//
import FoundationLib
import Foundation
class MockHttpClient: Networking {
    
    var showError = false
    
    var fileMapper = [
        "/list":"currencyList",
        "/live":"quoteList"
    ]
    
    func send<T>(_ request: RequestConvertable, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTaskProtocol? where T : ResponseConvertable {
        
        if showError {
            completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
        } else {
            let path = (try? request.toURLRequest().url?.path).unwrapped
            let jsonDataPath = fileMapper[path].unwrapped
            if let url = Bundle(for: CurrencyRepositoryTests.classForCoder()).url(forResource: jsonDataPath, withExtension: "json") {
                HttpClient.default.download(url, completion: completion)
            }
        }
        return EmptyURLSessionTask()
    }

}
