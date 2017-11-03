//
//  CollectionCell.swift
//  UnzipIt
//
//  Created by Fernando on 11/1/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

protocol CollectionCellDelegate: class {
    func loadImages(_ collection: Collection, _ sender: CollectionCell)
}

class CollectionCell: UITableViewCell {
    
    var collection: Collection!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var collectionImageDownloadButton: UIButton!
    @IBOutlet weak var collectionImageView: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    weak var delegate: CollectionCellDelegate?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(collection: Collection){
        self.collection = collection
        collectionNameLabel.text =  collection.collection_name
    }
    
    @IBAction func downloadImages(_ sender: UIButton) {
        
        delegate?.loadImages(collection, self)
    }
    

}
