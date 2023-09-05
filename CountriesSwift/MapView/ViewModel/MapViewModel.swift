//
//  MapViewModel.swift
//  CountriesSwift
//
//  Created by Jorge  Figueroa on 04/09/23.
//

import Foundation

class MapViewModel: NSObject {
    
    //MARK: Outputs.
    var bindingCountryRefresh: (([[String: Any]]) -> Void)?
    var idCountry: String
    
    private var xmlAuxiliar = [String: Any]()
    private var xmlDataArray = [[String: Any]]()
    private var currentElement = ""
    
    init(id: String) {
        self.idCountry = id
    }
    
    func viewDidLoad() {
        getCountry()
    }
    
    private func getCountry() {
        ServerCountries.getACountrieServer(type: .byCountry, id: self.idCountry) { data, error in
            guard error == nil,
                  let data = data else { return }
            let davResponse = XMLParser(data: data)
            davResponse.delegate = self
            davResponse.parse()
        }
    }
}

//MARK: - Delegados para parsear un xml.

extension MapViewModel: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "Estado" {
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
        if elementName == "Estado" {
            xmlDataArray.append(xmlAuxiliar)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        bindingCountryRefresh?(xmlDataArray)
    }
}
