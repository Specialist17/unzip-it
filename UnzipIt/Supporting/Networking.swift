//
//  Networking.swift
//  UnzipIt
//
//  Created by Fernando on 11/1/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import Foundation

class Networking {
    static let instance = Networking()
    
    let baseUrlString = "https://api.myjson.com/bins/1165qr"
    let session = URLSession.shared
    
    func fetch(route: String?, method: String, headers: [String: String], data: Encodable?, completion: @escaping (Data) -> Void) {
        let fullUrlString = baseUrlString
        
        let url = URL(string: fullUrlString)!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method
//        request.httpBody = route.body(data: data)
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            completion(data)
            }.resume()
        
    }
}
