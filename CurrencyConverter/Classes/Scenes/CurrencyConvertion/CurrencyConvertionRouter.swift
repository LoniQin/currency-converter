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
        viewModel.actions.forEach {
            alert.addAction($0)
        }
        viewController?.present(alert, animated: true)
    }
    
}
