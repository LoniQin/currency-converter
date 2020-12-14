//
//  CurrencyConversionViewControllerTests.swift
//  CurrencyConverterTests
//
//  Created by Lonnie on 2020/12/14.
//

import Foundation
import XCTest
@testable import CurrencyConverter

class CurrencyConversionViewControllerTests: XCTestCase {
    
    let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "currency_convertion") as! CurrencyConvertionViewController
    
    class Interactor: CurrencyConvertionBusinessLogic {
        var requestSetupViewCalled = false
        func requestSetupView(request: CurrencyConvertion.SetupViewRequest) {
            requestSetupViewCalled = true
        }
        
        var requestLoadingCalled = false
        func requestLoading(request: CurrencyConvertion.LoadingRequest) {
            requestLoadingCalled = true
        }
        
        var updateAmountCalled = false
        var amount: String = ""
        func updateAmount(request: CurrencyConvertion.UpdateAmountRequest) {
            updateAmountCalled = true
            self.amount = request.amount
        }
        
        var updateCurrencyCalled = false
        var selectedIndex = 0
        func updateCurrency(request: CurrencyConvertion.UpdateCurrencyRequest) {
            updateCurrencyCalled = true
            selectedIndex = request.selectedIndex
        }
        
        var requestExchangeRatesCalled = false
        func requestExchangeRates(request: CurrencyConvertion.ExchangeRatesRequest) {
            requestExchangeRatesCalled = true
        }
        
    }
    
    let interactor = Interactor()

    override func setUp() {
        super.setUp()
        viewController.interactor = interactor
        viewController.loadViewIfNeeded()
    }
    
    func testRequestSetupViewCalled() {
        XCTAssert(interactor.requestSetupViewCalled)
    }
    
    func testUpdateAmount() {
        viewController.amountField.text = "1.0"
        viewController.updateAmount(textField: viewController.amountField)
        XCTAssertTrue(interactor.updateAmountCalled)
        XCTAssertEqual(interactor.amount, "1.0")
    }
    
    func testRequestExchangeRates() {
        viewController.textFieldDidEndEditing(viewController.amountField)
        XCTAssertTrue(interactor.requestExchangeRatesCalled)
    }
    
    func testChooseCurrency() {
        let expectation = self.expectation(description: "Picker View ")
        viewController.pickerView(viewController.pickerView, didSelectRow: 3, inComponent: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssert(self.interactor.updateCurrencyCalled)
            XCTAssertEqual(self.interactor.selectedIndex, 3)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 2) { _ in
            
        }
    }
    
    func testDisplaySetUpView() {
        let viewModel = CurrencyConvertion.SetupViewViewModel(title: "Currency conversion", amountHint: "Please input amount..")
        viewController.displaySetupView(viewModel: viewModel)
        XCTAssertEqual(viewController.title, viewModel.title)
        XCTAssertEqual(viewController.amountField.placeholder, viewModel.amountHint)
    }
    
    func testDisplayLoading() {
        viewController.displayLoading(viewModel: .init(isAnimating: true))
        XCTAssert(viewController.indicator.isAnimating)
        XCTAssert(viewController.tableView.isHidden)
        XCTAssert(viewController.amountField.isHidden)
        XCTAssert(viewController.currencyLabel.isHidden)
        XCTAssert(viewController.chevronImageView.isHidden)
        viewController.displayLoading(viewModel: .init(isAnimating: false))
        XCTAssertFalse(viewController.indicator.isAnimating)
        XCTAssertFalse(viewController.tableView.isHidden)
        XCTAssertFalse(viewController.amountField.isHidden)
        XCTAssertFalse(viewController.currencyLabel.isHidden)
        XCTAssertFalse(viewController.chevronImageView.isHidden)
    }
    
    func testDisplayCurrency() {
        viewController.displayCurrency(viewModel: .init(selectedIndex: 2, currentCurrencyName: "USD"))
        XCTAssertEqual(viewController.selectedIndex, 2)
        XCTAssertEqual(viewController.currencyLabel.text, "USD")
    }
    
    func testDisplayCurrencyList() {
        let currencies = ["USD", "GBP", "SGD", "JPY"]
        viewController.displayCurrencyList(viewModel: .init(currencies: currencies))
        XCTAssertEqual(viewController.currentViewModel.currencies, currencies)
    }
    
    func testDisplayAmount() {
        viewController.displayAmount(viewModel: .init(amount: "33.3"))
        XCTAssertEqual(viewController.amountField.text, "33.3")
    }
    
    func testDisplayExchangeRates() {
        let items = ["1.5000 AED", "30.0000 USD", "100.0000 JPG"]
        viewController.displayExchangeRates(viewModel: .init(items: items))
        XCTAssertEqual(viewController.exchangeRatesViewModel.items, items)
    }
    
}