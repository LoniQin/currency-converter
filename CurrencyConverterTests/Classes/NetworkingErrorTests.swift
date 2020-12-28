//
//  NetworkingErrorTests.swift
//  CurrencyConverterTests
//
//  Created by Lonnie on 2020/12/28.
//

import Foundation
import FoundationLib
import XCTest
@testable import CurrencyConverter

class ErrorTests: XCTestCase {

    func testServerError() {
        let serverError = NetworkingError(ServerError(code: 404, info: "Not exist"))
        var isServerError = false
        if case .serverError(let error) = serverError {
            XCTAssertEqual(error.code, 404)
            XCTAssertEqual(error.info, "Not exist")
            isServerError = true
        }
        XCTAssert(isServerError)
        let nestedServerError = NetworkingError(serverError)
        isServerError = false
        if case .serverError(let error) = nestedServerError {
            XCTAssertEqual(error.code, 404)
            XCTAssertEqual(error.info, "Not exist")
            isServerError = true
        }
        XCTAssert(isServerError)
    }

    func testAnotherError() {
        enum MockError: Int, Error {
            
            case firstError
            
            case secondError
            
        }
        let unknownError = NetworkingError(MockError.firstError)
        var isUnknownError = false
        if case .unknownError(let error) = unknownError {
            XCTAssert(error is MockError)
            isUnknownError = true
        }
        XCTAssert(isUnknownError)
        isUnknownError = false
        let nestedUnknownError = NetworkingError(unknownError)
        if case .unknownError(let error) = nestedUnknownError {
            XCTAssert(error is MockError)
            isUnknownError = true
        }
        XCTAssert(isUnknownError)
    }
    
}
