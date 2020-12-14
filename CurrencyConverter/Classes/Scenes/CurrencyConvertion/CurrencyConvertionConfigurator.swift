//
//  CurrencyConvertionConfiguration.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/13.
//

import UIKit

class CurrencyConvertionConfigurator {
    static func makeViewController(configuration: CurrencyConvertionConfiguration) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "currency_convertion") as! CurrencyConvertionViewController
        let repository = CurrencyRepository(httpClient: configuration.httpClient, storage: configuration.storage)
        let interactor = CurrencyConvertionInteractor(configuration: configuration, repository: repository)
        let presenter = CurrencyConvertionPresenter(configuration: configuration)
        let router = CurrencyConvertionRouter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        presenter.router = router
        router.viewController = viewController
        return viewController
    }
}
