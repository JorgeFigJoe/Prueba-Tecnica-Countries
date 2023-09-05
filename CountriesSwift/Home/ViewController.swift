//
//  ViewController.swift
//  CountriesSwift
//
//  Created by Jorge  Figueroa on 04/09/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: HomeListCountriesViewModel?
    private var countries = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModel()
        setupTableView()
        viewModel?.viewDidLoad()
    }
    
    
    //MARK: - Setups
    private func setup() {
        self.title = "Countries"
    }
    
    private func setupViewModel() {
        viewModel = HomeListCountriesViewModel()
        
        viewModel?.bindingCountriesRefresh = { countries in
            self.countries = countries
            self.reloadTableView()
        }
        
        viewModel?.bindingOpenViewController = { vc in
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CountryTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryTableViewCell")
        
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - TableView methods
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(country: countries[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension ViewController: CountryTableViewCellDelegate {
    func selectedCountry(id: Int) {
        viewModel?.showMapView(countrySelected: id)
    }
}

