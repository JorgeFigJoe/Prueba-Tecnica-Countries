//
//  CountryTableViewCell.swift
//  CountriesSwift
//
//  Created by Jorge  Figueroa on 04/09/23.
//

import UIKit

protocol CountryTableViewCellDelegate: AnyObject {
    func selectedCountry(country: [String: Any])
}

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var openMapButton: UIButton!
    
    var delegate: CountryTableViewCellDelegate?
    private var country: [String: Any]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(country: [String: Any]) {
        guard let countryName = country["NombrePais"] as? String else { return }
        self.country = country
        countryNameLabel.text = countryName
    }
    
    @IBAction func didSelectCountry(_ sender: Any) {
        guard let country = country else { return }
        self.delegate?.selectedCountry(country: country)
    }
}
