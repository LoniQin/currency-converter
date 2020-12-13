//
//  CurrencyConvertionViewController.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/11.
//

import UIKit

protocol CurrencyConvertionDisplayLogic: AnyObject {
    func displaySetupView(viewModel: CurrencyConvertion.SetupViewViewModel)
}

class CurrencyConvertionViewController: UIViewController, CurrencyConvertionDisplayLogic {
    
    var interactor: CurrencyConvertionBusinessLogic?
    
    @IBOutlet weak var amountField: UITextField!
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var chevronImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.requestSetupView(request: .init())
    }
    
    @IBAction func chooseCurrency(_ sender: Any) {
        
    }
    
    func displaySetupView(viewModel: CurrencyConvertion.SetupViewViewModel) {
        title = viewModel.title
        currencyLabel.isHidden = true
        chevronImageView.isHidden = true
        tableView.isHidden = true
    }
    
}
