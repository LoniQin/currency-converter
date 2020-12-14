//
//  CurrencyConversionRouterTests.swift
//  CurrencyConverterTests
//
//  Created by Lonnie on 2020/12/14.
//

import FoundationLib
import Foundation
import XCTest
@testable import CurrencyConverter

class CurrencyConversionRouterTests: XCTestCase {

    let router = CurrencyConvertionRouter()
    
    class ViewController: CurrencyConvertionViewController {
        
        var presented = false
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
            super.present(viewControllerToPresent, animated: flag, completion: completion)
            presented = true
        }
    }
    
    let viewController = ViewController()
    
    override func setUp() {
        super.setUp()
        router.viewController = viewController
    }
    func testRouteToError() {
        let viewModel = CurrencyConvertion.ErrorViewModel(title: "", comfirmTitle: "", cancelTitle: "", retryBlock: {
            
        })
        router.routeToError(viewModel: viewModel)
        XCTAssertEqual(viewController.presented, true)
    }
}
