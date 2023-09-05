//
//  CountryTableViewCell.swift
//  CountriesSwift
//
//  Created by Jorge  Figueroa on 04/09/23.
//

import UIKit

protocol CountryTableViewCellDelegate: AnyObject {
    func selectedCountry(id: Int)
}

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var openMapButton: UIButton!
    
    var delegate: CountryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(country: [String: Any]) {
        guard let countryName = country["NombrePais"] as? String,
              let id = country["idPais"] as? String,
              let idTag = Int(id) else { return }
        openMapButton.tag = idTag
        countryNameLabel.text = countryName
    }
    
    @IBAction func didSelectCountry(_ sender: Any) {
//        let numbers = [0]
//        let _ = numbers[1]
        self.delegate?.selectedCountry(id: openMapButton.tag)
    }
}
