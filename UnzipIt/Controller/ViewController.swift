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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionImagesSegue" {
            if let destinationVC = segue.destination as? CollectionImagesController{
                if let collection = sender as? Collection {
                    destinationVC.collection = collection
                }
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let collection = collections[indexPath.row]
        
        performSegue(withIdentifier: "collectionImagesSegue", sender: collection)
    }
}


extension ViewController: CollectionCellDelegate {
    func loadImages(_ collection: Collection, _ sender: CollectionCell) {
        Networking.instance.downloadFile(withUrl: collection.zipped_images_url) { (url, progress) in
            
            let url_string = url.lastPathComponent.split(separator: ".")
            let my_string = url_string[0].replacingOccurrences(of: "+", with: " ")

//            let indexEndOfText = url_string.index(url_string.endIndex, offsetBy: -4)
//            let collectionName = url_string[..<indexEndOfText]
            
            let file_url = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(my_string)/_preview.png")
            
            DispatchQueue.main.async {
                guard let image_url = file_url?.path else {return}
                sender.collectionImageView.image = UIImage(contentsOfFile: image_url)
                sender.imageProgress.progress = Float(progress)
            }
            
        }
        
    }
}


