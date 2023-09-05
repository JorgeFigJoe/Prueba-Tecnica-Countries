//
//  HomeListCountriesViewModel.swift
//  CountriesSwift
//
//  Created by Jorge  Figueroa on 04/09/23.
//

import Foundation
import UIKit

class HomeListCountriesViewModel: NSObject {
    
    //MARK: Outputs.
    var bindingCountriesRefresh: (([[String: Any]]) -> Void)?
    var bindingOpenViewController: ((UIViewController) -> Void)?
    
    private var xmlAuxiliar = [String: Any]()
    private var xmlDataArray = [[String: Any]]()
    private var currentElement = ""
    
    func viewDidLoad() {
        getAllCountries()
    }
    
    private func getAllCountries() {
        ServerCountries.getACountrieServer(type: .allCountries) { data, error in
            guard error == nil,
                  let data = data else { return }
            let davResponse = XMLParser(data: data)
            davResponse.delegate = self
            davResponse.parse()
        }
    }
    
    func showMapView(countrySelected: Int) {
        guard let vc = UIStoryboard.init(name: "MapViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        vc.country = xmlDataArray[countrySelected - 1]
        bindingOpenViewController?(vc)
    }
}

//MARK: - Delegados para parsear un xml.

extension HomeListCountriesViewModel: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "Pais" {
            xmlAuxiliar = [:]
        } else {
            currentElement = elementName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if xmlAuxiliar[currentElement] == nil {
                xmlAuxiliar.updateValue(string, forKey: currentElement)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Pais" {
            xmlDataArray.append(xmlAuxiliar)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
         bindingCountriesRefresh?(xmlDataArray)
    }
}
