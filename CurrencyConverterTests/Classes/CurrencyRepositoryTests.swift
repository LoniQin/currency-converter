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
        repository.getCurrencyList { result in
            switch result {
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
        let successExpectation = self.expectation(description: "Get quote list succeeded")
        let failureExpectation = self.expectation(description: "Get quote list failed")
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
                    XCTFail(error.localizedDescription)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        httpClient.showError = true
        repository.getQuoteList { result in
            switch result {
            case .success:
                XCTFail("Failure")
            case .failure:
                failureExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1.0) { _ in
           
        }
    }

}
