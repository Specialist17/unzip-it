//
//  CollectionViewCell.swift
//  UnzipIt
//
//  Created by Fernando on 11/3/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionImageView: CustomImageView!
    
    func configureCell(collectionImage: URL){
        self.collectionImageView.image = UIImage(contentsOfFile: collectionImage.absoluteURL.relativePath)
    }
}
