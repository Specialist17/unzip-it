//
//  ViewController.swift
//  UnzipIt
//
//  Created by Fernando on 10/31/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit
import Zip
import Alamofire

class ViewController: UIViewController {
    
    var collections = [Collection]() {
        didSet{
            self.collectionTable.reloadData()
        }
    }
    @IBOutlet weak var collectionTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionTable.delegate = self
        collectionTable.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        Networking.instance.fetch(route: nil, method: "GET", headers: [:], data: nil) { (data) in
            
            let collection = try? JSONDecoder().decode([Collection].self, from: data)
            
            DispatchQueue.main.async {
                if let collectionModel = collection {
                    print(collectionModel)
                    self.collections = collectionModel
                    self.collectionTable.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = collectionTable.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        let collection = collections[indexPath.row]
        cell.delegate = self
        
        cell.configureCell(collection: collection)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
}


extension ViewController: CollectionCellDelegate {
    func loadImages(_ collection: Collection, _ sender: CollectionCell) {
        Networking.instance.downloadFile(withUrl: collection.zipped_images_url) { url in
            let file_exists = FileManager.default.fileExists(atPath: "\(url.absoluteString)/lion/3.jpeg")
            print(file_exists)
        }
        
    }
}


