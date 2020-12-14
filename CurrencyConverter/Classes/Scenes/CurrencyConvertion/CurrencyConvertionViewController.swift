//
//  CurrencyConvertionViewController.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/11.
//

import UIKit

protocol CurrencyConvertionDisplayLogic: AnyObject {
    func displaySetupView(viewModel: CurrencyConvertion.SetupViewViewModel)
    func displayLoading(viewModel: CurrencyConvertion.LoadingViewModel)
}

class CurrencyConvertionViewController: UIViewController, CurrencyConvertionDisplayLogic {
    
    var interactor: CurrencyConvertionBusinessLogic?
    
    @IBOutlet weak var amountField: UITextField!
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var chevronImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var currencies: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.requestSetupView(request: .init())
    }
    
    @IBAction func chooseCurrency(_ sender: Any) {
        
    }
    
    func displaySetupView(viewModel: CurrencyConvertion.SetupViewViewModel) {
        title = viewModel.title
        amountField.placeholder = viewModel.amountHint
        indicator.hidesWhenStopped = true
        tableView.tableFooterView = UIView()
        pickerView.delegate = self
    }
    
    func displayLoading(viewModel: CurrencyConvertion.LoadingViewModel) {
        if viewModel.isAnimating {
            indicator.startAnimating()
            amountField.isHidden = true
            currencyLabel.isHidden = true
            chevronImageView.isHidden = true
            tableView.isHidden = true
        } else {
            indicator.stopAnimating()
            amountField.isHidden = false
            currencyLabel.isHidden = false
            chevronImageView.isHidden = false
            tableView.isHidden = false
        }
    }
    
}

extension CurrencyConvertionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currencies[row]
    }
}
