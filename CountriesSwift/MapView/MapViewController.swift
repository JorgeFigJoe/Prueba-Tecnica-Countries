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
    var viewModel: MapViewModel?
    
    var country: [String: Any]?
    var countryAllInformation =  [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupLocation()
        setup()
        viewModel?.viewDidLoad()
    }
    
    private func setup() {
        guard let country = country,
              let countryName = country["NombrePais"] else { return }
        self.title = "\(countryName)"
    }
    
    private func setupViewModel() {
        let specificCountry = country?["idPais"] as? String
        viewModel = MapViewModel(id: specificCountry ?? "1")
        
        viewModel?.bindingCountryRefresh = { country in
            self.countryAllInformation = country
            self.updateAnnonationsMap()
        }
    }
    
    private func updateAnnonationsMap() {
        DispatchQueue.main.async {
            for city in self.countryAllInformation {
                let annotation = MKPointAnnotation()
                guard let coordinate = city["Coordenadas"] as? String else { return }
                let result = coordinate.components(separatedBy: ", ")
                guard let latitudeString = result.first,
                      let longitudeString = result.last,
                      let longitude = Double(longitudeString),
                      let country = self.country?["NombrePais"] as? String,
                      let state = city["EstadoNombre"] as? String,
                      let latitude = Double(latitudeString) else { return }
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotation.title = country
                annotation.subtitle = state
                self.mapView.addAnnotation(annotation)
            }
        }
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
        self.mapView.delegate = self
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

extension MapViewController:  MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let countryAnnonation = annotation.title,
              let cityAnnonation = annotation.subtitle else { return }
        debugPrint(countryAnnonation ?? "")
        debugPrint(cityAnnonation ?? "")
        debugPrint(annotation.coordinate)
    }
}
