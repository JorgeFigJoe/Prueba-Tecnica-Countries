//
//  ServerAllCountries.swift
//  CountriesSwift
//
//  Created by Jorge  Figueroa on 04/09/23.
//

import Foundation

enum CountriesEndPointType {
    case allCountries
    case byCountry
    
    func endpoint() -> String {
        switch self {
        case .allCountries:
            return "https://servicesoap.azurewebsites.net/ws/Paises.asmx?op=GetPaises"
        case .byCountry:
            return "https://servicesoap.azurewebsites.net/ws/Paises.asmx"
        }
    }
    
    func params(countryId: String?) -> String {
        switch self {
        case .allCountries:
            return """
                <?xml version="1.0" encoding="utf-8"?>
                <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
                <soap:Body>
                <GetPaises xmlns="http://tempuri.org/" />
                </soap:Body>
                </soap:Envelope>
                """
        case .byCountry:
            return """
                <?xml version="1.0" encoding="utf-8"?>
                <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
                <soap:Body>
                <GetEstadosbyPais xmlns="http://tempuri.org/">
                <idEstado>\(countryId ?? "")</idEstado>
                </GetEstadosbyPais>
                </soap:Body>
                </soap:Envelope>
                """
        }
    }
}

class ServerCountries {
    
    static func getAllCountriesServer(type: CountriesEndPointType, completion: @escaping (Data?, Error?) -> Void) {
        WebRequest.shared.request(url: type.endpoint(), method: .post, contentType: .xml, body: type.params(countryId: nil)) { (data, response, error) in
            if let error = error {
                completion(data, error)
            } else if let data = data {
                completion(data, nil)
            }
        }
    }
}
