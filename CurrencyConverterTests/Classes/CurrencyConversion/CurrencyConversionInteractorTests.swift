//
//  CurrencyConversionInteractorTests.swift
//  CurrencyConverterTests
//
//  Created by Lonnie on 2020/12/14.
//

import FoundationLib
import Foundation
import XCTest
@testable import CurrencyConverter

class CurrencyConversionInteractorTests: XCTestCase {
    
    lazy var httpClient = MockHttpClient()
    
    lazy var store = try! DataStoreManager(strategy: .memory)
    
    lazy var configuration = CurrencyConvertionConfiguration(
        httpClient: httpClient,
        storage: store,
        stringProvider: StringProvider()
    )
    
    lazy var interactor = CurrencyConvertionInteractor(
        configuration: configuration,
        repository: CurrencyRepository(httpClient: httpClient, storage: store))
    
    class Presenter: CurrencyConvertionPresentationLogic {
        
        var presentSetupViewCalled = false
        func presentSetupView(response: CurrencyConvertion.SetupViewResponse) {
            presentSetupViewCalled = true
        }
        
        var presentLoadingCalled = false
        func presentLoading(response: CurrencyConvertion.LoadingResponse) {
            presentLoadingCalled = true
        }
        
        var presentErrorCalled = false
        func presentError(response: CurrencyConvertion.ErrorResponse) {
            presentErrorCalled = true
        }
        
        func presentCurrencyList(response: CurrencyConvertion.CurrencyListResponse) {
            
        }
        
        func presentAmount(response: CurrencyConvertion.UpdateAmountResponse) {
            
        }
        
        var presentExchangeRatesCalled = false
        func presentExchangeRates(response: CurrencyConvertion.ExchangeRatesResponse) {
            presentExchangeRatesCalled = true
        }
        
        var presentCurrencyCalled = false
        func presentCurrency(response: CurrencyConvertion.UpdateCurrencyResponse) {
            presentCurrencyCalled = true
        }
        
        
    }
    
    let presenter = Presenter()

    override func setUp() {
        super.setUp()
        interactor.presenter = presenter
    }
    
    func testRequestSetupViewWithHappyFlow() {
        self.presenter.presentSetupViewCalled = false
        self.presenter.presentLoadingCalled = false
        self.presenter.presentCurrencyCalled = false
        self.presenter.presentExchangeRatesCalled = false
        let expectation = self.expectation(description: #function)
        httpClient.showError = false
        interactor.requestSetupView(request: .init())
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssert(self.presenter.presentSetupViewCalled)
            XCTAssert(self.presenter.presentLoadingCalled)
            XCTAssert(self.presenter.presentCurrencyCalled)
            XCTAssert(self.presenter.presentExchangeRatesCalled)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 2) { _ in
            
        }
    }
    
    func testRequestSetupViewWithCurrencyListFail() {
        self.presenter.presentSetupViewCalled = false
        self.presenter.presentLoadingCalled = false
        self.presenter.presentCurrencyCalled = false
        self.presenter.presentExchangeRatesCalled = false
        let expectation = self.expectation(description: #function)
        httpClient.showError = true
        interactor.requestSetupView(request: .init())
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssert(self.presenter.presentSetupViewCalled)
            XCTAssert(self.presenter.presentLoadingCalled)
            XCTAssertFalse(self.presenter.presentCurrencyCalled)
            XCTAssertFalse(self.presenter.presentExchangeRatesCalled)
            XCTAssert(self.presenter.presentErrorCalled)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 2) { _ in
            
        }
    }
    
    func testGetQuoteListWithError() {
        self.presenter.presentSetupViewCalled = false
        self.presenter.presentLoadingCalled = false
        self.presenter.presentCurrencyCalled = false
        self.presenter.presentExchangeRatesCalled = false
        let expectation = self.expectation(description: #function)
        httpClient.showError = true
        interactor.getQuoteList {
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssert(self.presenter.presentLoadingCalled)
            XCTAssert(self.presenter.presentErrorCalled)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 2) { _ in
            
        }
    }
  
}
