//
//  ExtensionTests.swift
//  CurrencyConverterTests
//
//  Created by Lonnie on 2020/12/14.
//

import XCTest
import Foundation
@testable import CurrencyConverter
class ExtensionTests: XCTestCase {
    
    func testDouble() {
        let value = 1.0
        XCTAssertEqual(value.minute, 60.0)
    }

}
