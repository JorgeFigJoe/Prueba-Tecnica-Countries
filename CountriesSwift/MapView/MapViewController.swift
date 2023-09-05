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
    private var viewModel: MapViewModel?
    private var preview: PreviewView?
    private var id: Int?
    var countryAllInformation =  [[String: Any]]()
    
    var country: [String: Any]? {
        didSet {
            setup()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupLocation()
        viewModel?.viewDidLoad()
    }
    
    //MARK: - Setup methods.
    private func setup() {
        guard let country = country,
              let idString = country["idPais"] as? String,
              let id = Int(idString),
              let countryName = country["NombrePais"] else { return }
        self.title = "\(countryName)"
        self.id = id
    }
    
    private func setupViewModel() {
        guard let id = self.id else { return }
        viewModel = MapViewModel(id: id)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        removePreview()
    }
    
    private func showPreview(country: String, city: String, coordinates: CLLocationCoordinate2D) {
        preview?.removeFromSuperview()
        preview = PreviewView(frame: .zero)
        guard let previewView = preview else { return }
        view.addSubview(previewView)
        previewView.setupView(country: country, city: city, coordinates: coordinates)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        previewView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.7).isActive = true
        previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func removePreview() {
        preview?.removeFromSuperview()
        preview = nil
    }
}

//MARK: - Location user manager.
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

//MARK: - Control select annonations.
extension MapViewController:  MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let countryAnnonation = annotation.title,
              let cityAnnonation = annotation.subtitle else { return }
        showPreview(country: countryAnnonation ?? "", city: cityAnnonation ?? "", coordinates: annotation.coordinate)
    }
}
