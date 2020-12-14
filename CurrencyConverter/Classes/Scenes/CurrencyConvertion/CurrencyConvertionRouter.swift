//
//  CurrencyConvertionRouter.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/13.
//
import UIKit
import Foundation
protocol CurrencyConvertionRoutingLogic: AnyObject {
    func routeToError(viewModel: CurrencyConvertion.ErrorViewModel)
}
class CurrencyConvertionRouter: CurrencyConvertionRoutingLogic {
    
    weak var viewController: CurrencyConvertionViewController?
    
    func routeToError(viewModel: CurrencyConvertion.ErrorViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: nil, preferredStyle: .alert)
        alert.addAction(.init(title: viewModel.comfirmTitle, style: .default, handler: { (action) in
            viewModel.retryBlock()
        }))
        alert.addAction(.init(title: viewModel.cancelTitle, style: .cancel, handler: nil))
        viewController?.present(alert, animated: true)
    }
    
}
