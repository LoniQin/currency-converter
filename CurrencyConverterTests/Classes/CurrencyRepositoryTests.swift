//
//  CurrencyRepositoryTests.swift
//  CurrencyConverterTests
//
//  Created by Lonnie on 2020/12/14.
//
import FoundationLib
import XCTest
@testable import CurrencyConverter

class CurrencyRepositoryTests: XCTestCase {
    
    class EmptyURLSessionTask: URLSessionTaskProtocol {
        
        func resume() {
            
        }
        
        func cancel() {
            
        }
        
        func suspend() {
            
        }
    }
    
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
    
    let httpClient = MockHttpClient()
    
    let storage = try! DataStoreManager(strategy: .memory)
    
    override func setUp() {
        super.setUp()
        
    }
    
    func testGetCurrencyList() {
        let successExpectation = self.expectation(description: "Get currency list succeeded")
        let failureExpectation = self.expectation(description: "Get currency list failed")
        let repository = CurrencyRepository(httpClient: httpClient, storage: storage)
        httpClient.showError = false
        repository.getCurrencyList { [unowned self] list in
            switch list {
            case .success(let data):
                XCTAssertFalse(data.currencies.isEmpty)
                do {
                    let currencyList: CurrencyList = try self.storage.get(CurrencyRepository.Constants.currencyListKey)
                    XCTAssert(currencyList.currencies.count == data.currencies.count)
                    successExpectation.fulfill()
                } catch let error {
                    XCTAssertThrowsError(error)
                }
            case .failure(let error):
                XCTAssertThrowsError(error)
            }
        }
        httpClient.showError = true
        repository.getCurrencyList { list in
            switch list {
            case .success:
                XCTAssertThrowsError("Failure")
            case .failure:
                failureExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0) { _ in
           
        }
    }
    
    func testGetQuoteList() {
        let successExpectation = self.expectation(description: "Get currency list succeeded")
        let failureExpectation = self.expectation(description: "Get currency list failed")
        let repository = CurrencyRepository(httpClient: httpClient, storage: storage)
        httpClient.showError = false
        repository.getQuoteList { [unowned self] result in
            switch result {
            case .success(let data):
                XCTAssertFalse(data.quotes.isEmpty)
                do {
                    let currencyList: QuoteList = try self.storage.get(CurrencyRepository.Constants.quoteListKey)
                    XCTAssert(currencyList.quotes.count == data.quotes.count)
                    successExpectation.fulfill()
                } catch let error {
                    XCTAssertThrowsError(error)
                }
            case .failure(let error):
                XCTAssertThrowsError(error)
            }
        }
        httpClient.showError = true
        repository.getQuoteList { list in
            switch list {
            case .success:
                XCTAssertThrowsError("Failure")
            case .failure:
                failureExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0) { _ in
           
        }
    }

}
