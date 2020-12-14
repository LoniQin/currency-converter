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
    
    func displayCurrencyList(viewModel: CurrencyConvertion.CurrencyListViewModel)
    
    func displayAmount(viewModel: CurrencyConvertion.UpdateAmountViewModel)
    
    func displayExchangeRates(viewModel: CurrencyConvertion.ExchangeRatesViewModel)
    
    func displayCurrency(viewModel: CurrencyConvertion.UpdateCurrencyViewModel)
    
    func displayNoData(viewModel: CurrencyConvertion.NoDataViewModel)
    
}

class CurrencyConvertionViewController: UIViewController, CurrencyConvertionDisplayLogic {
    
    struct Constants {
        
        static let reuseIdentifier = "item"
        
        static let animationDuration = 0.3
        
        static let separatorHeight: CGFloat = 1
        
        static let pickerViewHiddenConstant: CGFloat = 0
    }
    
    var interactor: CurrencyConvertionBusinessLogic?
    
    @IBOutlet weak var amountField: UITextField!
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var chevronImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var currencyStackView: UIStackView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var pickViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    var selectedIndex = 0
    
    var currentViewModel = CurrencyConvertion.CurrencyListViewModel(currencies: [])
    
    var exchangeRatesViewModel = CurrencyConvertion.ExchangeRatesViewModel(items: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.requestSetupView(request: .init())
    }
    
    @objc func togglePickerView(completion: @escaping ()->Void = {}) {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.pickViewBottomConstraint.constant = (self.pickViewBottomConstraint.constant == Constants.pickerViewHiddenConstant) ? -(self.pickerView.frame.size.height + self.view.safeAreaInsets.bottom) : Constants.pickerViewHiddenConstant
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
        
    }
    
    @objc func chooseCurrency() {
        togglePickerView()
    }
    
    func displaySetupView(viewModel: CurrencyConvertion.SetupViewViewModel) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(refresh))
        title = viewModel.title
        view.backgroundColor = UIColor.white
        pickerView.backgroundColor = UIColor.white
        amountField.placeholder = viewModel.amountHint
        amountField.keyboardType = .decimalPad
        amountField.delegate = self
        indicator.hidesWhenStopped = true
        pickerView.layer.shadowRadius = 8
        pickerView.layer.masksToBounds = false
        pickerView.layer.shadowColor = UIColor.black.cgColor
        pickerView.layer.shadowOffset = .init(width: 0, height: -3)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        pickerView.delegate = self
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: Constants.reuseIdentifier
        )
        amountField.addTarget(self, action: #selector(updateAmount(textField:)), for: .allEditingEvents)
        currencyStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseCurrency)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        let line = UIView()
        line.backgroundColor = .separator
        pickerView.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        pickerView.addConstraints([
            line.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor),
            line.topAnchor.constraint(equalTo: pickerView.topAnchor),
            line.heightAnchor.constraint(equalToConstant: Constants.separatorHeight)
        ])
    }
    
    @objc func refresh() {
        interactor?.refreshData(request: .init())
    }
    
    @objc func updateAmount(textField: UITextField) {
        interactor?.updateAmount(
            request: .init(
                amount: textField.text.unwrapped
            )
        )
    }
    
    @objc func dismissKeyboard() {
        amountField.resignFirstResponder()
    }
    
    func displayLoading(viewModel: CurrencyConvertion.LoadingViewModel) {
        if viewModel.isAnimating {
            indicator.startAnimating()
            noDataLabel.isHidden = true
            amountField.isHidden = true
            currencyLabel.isHidden = true
            chevronImageView.isHidden = true
            tableView.isHidden = true
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            indicator.stopAnimating()
            noDataLabel.isHidden = true
            amountField.isHidden = false
            currencyLabel.isHidden = false
            chevronImageView.isHidden = false
            tableView.isHidden = false
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func displayCurrency(viewModel: CurrencyConvertion.UpdateCurrencyViewModel) {
        self.selectedIndex = viewModel.selectedIndex
        self.currencyLabel.text = viewModel.currentCurrencyName
    }
    
    func displayCurrencyList(viewModel: CurrencyConvertion.CurrencyListViewModel) {
        self.currentViewModel = viewModel
        self.pickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
        self.pickerView.reloadAllComponents()
    }
    
    func displayAmount(viewModel: CurrencyConvertion.UpdateAmountViewModel) {
        self.amountField.text = viewModel.amount
    }
    
    func displayExchangeRates(viewModel: CurrencyConvertion.ExchangeRatesViewModel) {
        self.exchangeRatesViewModel = viewModel
        self.tableView.reloadData()
    }
    
    func displayNoData(viewModel: CurrencyConvertion.NoDataViewModel) {
        noDataLabel.text = viewModel.title
        noDataLabel.isHidden = false
        amountField.isHidden = true
        currencyLabel.isHidden = true
        chevronImageView.isHidden = true
        tableView.isHidden = true
    }
    
}

extension CurrencyConvertionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currentViewModel.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currentViewModel.currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(#function, row)
        togglePickerView { [weak self] in
            self?.interactor?.updateCurrency(request: .init(selectedIndex: row))
        }
    }
    
}


extension CurrencyConvertionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier)!
        cell.textLabel?.text = exchangeRatesViewModel.items[indexPath.row]
        cell.textLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exchangeRatesViewModel.items.count
    }
}

extension CurrencyConvertionViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        interactor?.requestExchangeRates(request: .init())
    }
}
