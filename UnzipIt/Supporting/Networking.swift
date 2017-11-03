//
//  Networking.swift
//  UnzipIt
//
//  Created by Fernando on 11/1/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import Foundation
import Alamofire
import Zip

class Networking {
    static let instance = Networking()
    
    let baseUrlString = "https://api.myjson.com/bins/17i2zn"
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
    
    
    func downloadFile(withUrl urlString: String, completion: @escaping (URL) -> Void){
        //Create URL to the source file you want to download
        let fileURL = URL(string: urlString)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url:fileURL!)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                let documentsDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                Zip.addCustomFileExtension("tmp")
                try? Zip.unzipFile(tempLocalUrl, destination: documentsDirectory, overwrite: true, password: nil, progress: { (progress) -> () in
                    print(progress)
                }) // Unzip
                completion(documentsDirectory)
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }
    
    func alamofireLoad(collection: Collection){
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("Forrest/images.zip")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(collection.zipped_images_url, to: destination).response { response in
            print(response)
            
            if response.error == nil, let imagePath = response.destinationURL?.path {
                //                let image = UIImage(contentsOfFile: imagePath)
                do {
                    
                    let documentsDirectory = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
                    try Zip.unzipFile(response.destinationURL!, destination: documentsDirectory, overwrite: true, password: nil, progress: { (progress) -> () in
                        print(progress)
                    }) // Unzip
                    
                }
                catch {
                    print("Something went wrong")
                }
            }
        }
    }
}
