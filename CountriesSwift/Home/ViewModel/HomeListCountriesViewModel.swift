//
//  HomeListCountriesViewModel.swift
//  CountriesSwift
//
//  Created by Jorge  Figueroa on 04/09/23.
//

import Foundation

class HomeListCountriesViewModel: NSObject {
    
    //MARK: Outputs.
    var bindingCountriesRefresh: (([[String: Any]]) -> Void)?
    
    private var xmlDict = [String: Any]()
    private var xmlDictArr = [[String: Any]]()
    private var currentElement = ""
    
    func viewDidLoad() {
        getAllCountries()
    }
    
    private func getAllCountries() {
        ServerCountries.getAllCountriesServer(type: .allCountries) { data, error in
            guard error == nil,
                  let data = data else { return }
            let davResponse = XMLParser(data: data)
            davResponse.delegate = self
            davResponse.parse()
        }
    }
}

//MARK: - Delegados para parsear un xml.

extension HomeListCountriesViewModel: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "Pais" {
            xmlDict = [:]
        } else {
            currentElement = elementName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if xmlDict[currentElement] == nil {
                   xmlDict.updateValue(string, forKey: currentElement)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Pais" {
                xmlDictArr.append(xmlDict)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
         bindingCountriesRefresh?(xmlDictArr)
    }
}
