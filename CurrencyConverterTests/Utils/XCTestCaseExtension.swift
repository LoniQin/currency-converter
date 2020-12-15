//
//  XCTestCaseExtension.swift
//  CurrencyConverterTests
//
//  Created by Lonnie on 2020/12/16.
//
import XCTest
import Foundation
extension XCTestCase {
    func makeExpextation(
        description: String = #function,
        timeout: Double = 2,
        block: (XCTestExpectation) -> Void
    ) {
        let expectaion = self.expectation(description: description)
        block(expectaion)
        self.waitForExpectations(timeout: timeout) { error in
            if let error = error {
                XCTAssertThrowsError(error)
            }
        }
    }
}
