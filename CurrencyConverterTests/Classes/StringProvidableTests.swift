//
//  StringProvidableTests.swift
//  CurrencyConverterTests
//
//  Created by Lonnie on 2020/12/14.
//
import XCTest
import Foundation
@testable import CurrencyConverter
class StringProvidableTests: XCTestCase {
    
    func testStringProvider() {
        let provider = StringProvider()
        XCTAssertEqual(provider.cancel(), "Cancel")
        XCTAssertEqual(provider.retry(), "Retry")
        XCTAssertEqual(provider.networkError(), "Network error")
        XCTAssertEqual(provider.currencyConvertionTitle(), "Currency Converter")
        XCTAssertEqual(provider.currencyConvertionInputAmountHint(), "Please input amount...")
    }

}
