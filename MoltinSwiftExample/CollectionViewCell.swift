//
//  ProductsListTableViewCell.swift
//  MoltinSwiftExample
//
//  Created by Dylan McKee on 16/08/2015.
//  Copyright (c) 2015 Moltin. All rights reserved.
//

import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    
    //ProductCollectionController
    @IBOutlet weak var productNameLabel:UILabel?
    @IBOutlet weak var productPriceLabel:UILabel?
    @IBOutlet weak var productImageView:UIImageView?
    
    // SnapshotController
    @IBOutlet weak var collectionLabel:UILabel?
    @IBOutlet weak var collectionImage:UIImageView?
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    
    func configureWithProduct(productDict: NSDictionary) {
       
        productNameLabel?.text = productDict.valueForKey("title") as? String
        productNameLabel?.font = Font.collectlabel1
        productNameLabel?.textColor = Color.moltinColor
        
        productPriceLabel?.text = productDict.valueForKeyPath("price.data.formatted.with_tax") as? String
        
        var imageUrl = ""
        
        if let images = productDict.objectForKey("images") as? NSArray {
            if (images.firstObject != nil) {
                imageUrl = images.firstObject?.valueForKeyPath("url.https") as! String
            }
        }

        productImageView?.sd_setImageWithURL(NSURL(string: imageUrl))
    }
    
    
    func setCollectionAdvertiser(dict: NSDictionary) {
        // Set up the cell based on the values of the dictionary that we've been passed
        
        collectionLabel?.text = ""
        //collectionLabel?.font = Font.collectlabel
        
        var imageUrl = ""
        
        if let images = dict.valueForKey("images") as? NSArray {
            if (images.firstObject != nil) {
                imageUrl = images.firstObject?.valueForKeyPath("url.https") as! String
            }
        }
        
        collectionImage?.sd_setImageWithURL(NSURL(string: imageUrl))
    }
    
    
    func setCollectionDictionary(dict: NSDictionary) {
        // Set up the cell based on the values of the dictionary that we've been passed
        
        collectionLabel?.text = "Shop \(dict.valueForKey("title") as! String)"
        collectionLabel?.font = Font.collectlabel
        collectionLabel?.textColor = Color.appColor
        
        var imageUrl = ""
        
        if let images = dict.valueForKey("images") as? NSArray {
            if (images.firstObject != nil) {
                imageUrl = images.firstObject?.valueForKeyPath("url.https") as! String
            }
        }
        
        collectionImage?.sd_setImageWithURL(NSURL(string: imageUrl))
    }

}
