//
//  WebRequest.swift
//  CountriesSwift
//
//  Created by Jorge  Figueroa on 04/09/23.
//

import Foundation

enum ContentType: String {
    case json = "application/json"
    case xml = "text/xml"
}

enum RequestMethod: String {
    case put = "PUT"
    case post = "POST"
    case get = "GET"
}

class WebRequest {
    
    static let shared = WebRequest()
    private let session = URLSession.shared
    
    private init() { }
    
    func request(url: String, method: RequestMethod, contentType: ContentType, body: String? = nil, additionalHeaders: [String:String]? = nil, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let urlObject = URL(string: url) else {
            return
        }
        
        let request = NSMutableURLRequest(url: urlObject)
        
        addDefaultHeadersTo(request: request, contentType: contentType)
        request.httpMethod = method.rawValue
        if let body = body {
            request.httpBody = body.data(using: .utf8)
        }
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            completionHandler(data, response, error)
        }
        task.resume()
    }

    
    private func addDefaultHeadersTo(request: NSMutableURLRequest, contentType: ContentType, addAuthorization: Bool = true) {
        request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
    }
}
