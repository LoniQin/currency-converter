//
//  CurrencyPresenterTests.swift
//  CurrencyConverterTests
//
//  Created by Lonnie on 2020/12/14.
//

import FoundationLib
import Foundation
import XCTest
@testable import CurrencyConverter

class CurrencyConversionPresenterTests: XCTestCase {
    
    lazy var httpClient = MockHttpClient()
    
    lazy var store = try! DataStoreManager(strategy: .memory)
    
    lazy var configuration = CurrencyConvertionConfiguration(
        httpClient: httpClient,
        storage: store,
        stringProvider: StringProvider()
    )
    
    lazy var presenter = CurrencyConvertionPresenter(configuration: configuration)
    
    class ViewController: CurrencyConvertionDisplayLogic {
        
        var displaySetupViewCalled = false
        func displaySetupView(viewModel: CurrencyConvertion.SetupViewViewModel) {
            displaySetupViewCalled = true
        }
        
        var displayLoadingCalled = false
        func displayLoading(viewModel: CurrencyConvertion.LoadingViewModel) {
            displayLoadingCalled = true
        }
        
        var displayCurrencyListCalled = false
        func displayCurrencyList(viewModel: CurrencyConvertion.CurrencyListViewModel) {
            displayCurrencyListCalled = true
        }
        
        var displayAmountCalled = false
        var amount = ""
        func displayAmount(viewModel: CurrencyConvertion.UpdateAmountViewModel) {
            displayAmountCalled = true
            amount = viewModel.amount
        }
        
        var displayExchangeRatesCalled = false
        var exchangeRates = [String]()
        func displayExchangeRates(viewModel: CurrencyConvertion.ExchangeRatesViewModel) {
            displayExchangeRatesCalled = true
            exchangeRates = viewModel.items
        }
        
        var displayCurrencyCalled = false
        func displayCurrency(viewModel: CurrencyConvertion.UpdateCurrencyViewModel) {
            displayCurrencyCalled = true
        }
        
        
    }
    
    class Router: CurrencyConvertionRoutingLogic {
        var routeToErrorCalled = false
        func routeToError(viewModel: CurrencyConvertion.ErrorViewModel) {
            routeToErrorCalled = true
        }
    }
    
    let viewController = ViewController()
    
    let router = Router()

    override func setUp() {
        super.setUp()
        presenter.viewController = viewController
        presenter.router = router
    }
    
    func testPresentSetUpView() {
        presenter.presentSetupView(response: .init())
        XCTAssert(viewController.displaySetupViewCalled)
    }
    
    func testPresentLoading() {
        presenter.presentLoading(response: .init(loading: true))
        XCTAssert(viewController.displayLoadingCalled)
    }
    
    func testPresentCurrencyList() {
        presenter.presentCurrencyList(response: .init(currencyList: CurrencyList(["USD": "", "SGD": ""])))
        XCTAssert(viewController.displayCurrencyListCalled)
    }
    
    func testPresentCurrency() {
        presenter.presentCurrency(response: .init(selectedIndex: 0, currency: Currency(name: "USD", detail: "")))
        XCTAssert(viewController.displayCurrencyCalled)
    }
    
    func testPresentError() {
        presenter.presentError(response: .init(error: .serverError(ServerError(code: 404, info: "Not found")), retryBlock: {
            
        }))
        XCTAssert(router.routeToErrorCalled)
    }
    
    func testPresentAmount() {
        presenter.presentAmount(response: .init(amount: "1.2"))
        XCTAssert(viewController.displayAmountCalled)
        XCTAssertEqual(viewController.amount, "1.2")
        presenter.presentAmount(response: .init(amount: "11.22"))
        XCTAssertEqual(viewController.amount, "11.22")
    }
    
    func testPresentExchangeRates() {
        presenter.presentExchangeRates(
            response: .init(
                exchangeRates: [
                    ExchangeRate(amount: 1.2, currency: "USD"),
                    ExchangeRate(amount: 1.11993, currency: "GBP"),
        ]))
        XCTAssert(viewController.displayExchangeRatesCalled)
        XCTAssertEqual(viewController.exchangeRates, ["1.2000 USD", "1.1199 GBP"])
    }
    
}
