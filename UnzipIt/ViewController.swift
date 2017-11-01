//
//  ViewController.swift
//  UnzipIt
//
//  Created by Fernando on 10/31/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import Zip

class ViewController: UIViewController {
    
    var collections = [Collection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Networking.instance.fetch(route: nil, method: "GET", headers: [:], data: nil) { (data) in
            
            let collection = try? JSONDecoder().decode([Collection].self, from: data)
            
            DispatchQueue.main.async {
                if let collectionModel = collection {
                    print(collectionModel)
                    self.collections = collectionModel
                    self.downloadZipfiles()
                    
//                    do {
//                        let filePath = Bundle.main.url(forResource: "downloadedFile2", withExtension: "zip")!
//                        let unzipDirectory = try Zip.quickUnzipFile(filePath) // Unzip
//                    }
//                    catch {
//                        print("Something went wrong")
//                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadZipfiles(){
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        let destinationFileUrl = documentsUrl.appendingPathComponent("downloadedFile.zip")
        
        //Create URL to the source file you want to download
        let fileURL = URL(string: collections[0].zipped_images_url)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url:fileURL!)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
                
//                let filePath = Bundle.main.url(forResource: "downloadedFile", withExtension: "zip")!
//                let unzipDirectory = try? Zip.quickUnzipFile(filePath) // Unzip
//                print(unzipDirectory)
                
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }


}

