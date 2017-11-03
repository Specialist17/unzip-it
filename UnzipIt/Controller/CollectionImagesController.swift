//
//  CollectionImagesController.swift
//  UnzipIt
//
//  Created by Fernando on 11/2/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

class CollectionImagesController: UIViewController {

    @IBOutlet weak var imagesCollection: UICollectionView!
    var imageNames = [URL]()
    var collection: Collection!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesCollection.dataSource = self
        imagesCollection.delegate = self
        
        let collection_string = collection.zipped_images_url
        let url = URL(string: collection_string)!
        
        let url_string = url.lastPathComponent
        
        let indexEndOfText = url_string.index(url_string.endIndex, offsetBy: -4)
        let collectionName = url_string[..<indexEndOfText]
        
        let fm = FileManager.default
        let file_url = try? fm.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(collectionName)")
        
        let contents = try? fm.contentsOfDirectory(at: file_url!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        if let contents = contents {
            imageNames = contents.filter({ $0.absoluteString.contains(".jpg") || $0.absoluteString.contains(".jpeg")})
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension CollectionImagesController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesCollection.dequeueReusableCell(withReuseIdentifier: "CollectionImagesCell", for: indexPath) as! CollectionViewCell
        
        let path = imageNames[indexPath.row]
        
        cell.configureCell(collectionImage: path)
        
        return cell
    }
    
    
}

