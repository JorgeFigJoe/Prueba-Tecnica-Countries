//
//  PreviewView.swift
//  CountriesSwift
//
//  Created by Jorge  Figueroa on 05/09/23.
//

import UIKit
import CoreLocation

class PreviewView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var estateLabel: UILabel!
    @IBOutlet weak var latitudeValueLabel: UILabel!
    @IBOutlet weak var longitudeValueLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func commonInitialization() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("PreviewView", owner: self, options: nil)
        addSubview(contentView)

        contentView.frame = .zero
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setupView(country: String, city: String, coordinates: CLLocationCoordinate2D) {
        countryLabel.text = country
        estateLabel.text = city
        latitudeValueLabel.text = "\(coordinates.latitude)"
        longitudeValueLabel.text = "\(coordinates.longitude)"
    }
}
