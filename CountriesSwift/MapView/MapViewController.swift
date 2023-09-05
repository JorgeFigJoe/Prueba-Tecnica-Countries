//
//  MapViewController.swift
//  CountriesSwift
//
//  Created by Jorge  Figueroa on 04/09/23.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    
    var country = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
    }
}

//MARK: - Control de la ubicación de usuario.
extension MapViewController: CLLocationManagerDelegate {
    private func setupLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors " + error.localizedDescription)
    }
}
