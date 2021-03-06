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
        
        var presentCurrencyListCalled = false
        func presentCurrencyList(response: CurrencyConvertion.CurrencyListResponse) {
            presentCurrencyListCalled = true
        }
        
        var presentAmountCalled = false
        var amount = ""
        func presentAmount(response: CurrencyConvertion.UpdateAmountResponse) {
            presentAmountCalled = true
            amount = response.amount
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
    
    func testRefreshDataWithHappyFlow() {
        makeExpextation { expectation in
            self.presenter.presentSetupViewCalled = false
            self.presenter.presentLoadingCalled = false
            self.presenter.presentCurrencyCalled = false
            self.presenter.presentExchangeRatesCalled = false
            httpClient.showError = false
            interactor.refreshData(request: .init())
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssert(self.presenter.presentLoadingCalled)
                XCTAssert(self.presenter.presentCurrencyCalled)
                XCTAssert(self.presenter.presentCurrencyCalled)
                XCTAssert(self.presenter.presentExchangeRatesCalled)
                expectation.fulfill()
            }
        }
    }
    
    func testRefreshDataWithUnHappyFlow() {
        makeExpextation { expectation in
            self.presenter.presentLoadingCalled = false
            self.presenter.presentCurrencyCalled = false
            self.presenter.presentExchangeRatesCalled = false
            httpClient.showError = true
            interactor.refreshData(request: .init())
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssert(self.presenter.presentLoadingCalled)
                XCTAssertFalse(self.presenter.presentCurrencyListCalled)
                XCTAssertFalse(self.presenter.presentExchangeRatesCalled)
                XCTAssert(self.presenter.presentErrorCalled)
                expectation.fulfill()
            }
        }
    }
    
    func testSetupView() {
        interactor.requestSetupView(request: .init())
        XCTAssert(self.presenter.presentSetupViewCalled)
    }
    
    func testGetQuoteListWithError() {
        makeExpextation { expectation in
            self.presenter.presentSetupViewCalled = false
            self.presenter.presentLoadingCalled = false
            self.presenter.presentCurrencyCalled = false
            self.presenter.presentExchangeRatesCalled = false
            httpClient.showError = true
            interactor.getQuoteList {
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssert(self.presenter.presentLoadingCalled)
                XCTAssert(self.presenter.presentErrorCalled)
                expectation.fulfill()
            }
        }
    }
    
    func testUpdateAmount() {
        interactor.updateAmount(request: .init(amount: "2.3"))
        XCTAssert(presenter.presentAmountCalled)
        XCTAssertEqual(presenter.amount, "2.3")
        interactor.updateAmount(request: .init(amount: "2."))
        XCTAssertEqual(presenter.amount, "2.")
        interactor.updateAmount(request: .init(amount: "2.."))
        XCTAssertEqual(presenter.amount, "2.")
        interactor.updateAmount(request: .init(amount: ""))
        XCTAssertEqual(presenter.amount, "")
    }
    
    func testUpdateCurrency() {
        makeExpextation { expectation in
            presenter.presentCurrencyCalled = false
            presenter.presentLoadingCalled = false
            presenter.presentExchangeRatesCalled = false
            presenter.presentLoadingCalled = false
            httpClient.showError = false
            interactor.currencyList = CurrencyList(["HRK" : "Croatian Kuna",
                                                   "HUF" : "Hungarian Forint",
                                                   "CDF" : "Congolese Franc",
                                                   "ILS" : "Israeli New Sheqel",
                                                   "NGN" : "Nigerian Naira",
                                                   "GYD" : "Guyanaese Dollar",
                                                   "BYR" : "Belarusian Ruble",
                                                   "BHD" : "Bahraini Dinar",
                                                   "SZL" : "Swazi Lilangeni",
                                                   "INR" : "Indian Rupee",
                                                   "SDG" : "Sudanese Pound",
                                                   "PEN" : "Peruvian Nuevo Sol",
                                                   "EUR" : "Euro",
                                                   "QAR" : "Qatari Rial",
                                                   "PGK" : "Papua New Guinean Kina",
                                                   "LRD" : "Liberian Dollar",
                                                   "ISK" : "Icelandic Króna",
                                                   "SYP" : "Syrian Pound",
                                                   "TRY" : "Turkish Lira"])
            interactor.updateCurrency(request: .init(selectedIndex: 1))
            XCTAssertEqual(interactor.selectedIndex, 1)
            XCTAssertTrue(presenter.presentLoadingCalled)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertTrue(self.presenter.presentCurrencyCalled)
                XCTAssertTrue(self.presenter.presentExchangeRatesCalled)
                expectation.fulfill()
            }
        }
    }
    
    func testRequestExchangeRates() {
        makeExpextation { expectation in
            presenter.presentExchangeRatesCalled = true
            httpClient.showError = false
            interactor.getCurrencyListAndExchangeRates { [weak self] in
                self?.interactor.requestExchangeRates(request: .init())
                XCTAssertEqual(self?.presenter.presentExchangeRatesCalled, true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                expectation.fulfill()
            }
        }
    }
  
}
