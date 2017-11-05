//
//  ProductCollectionViewCell.swift
//  MyShoppingApp
//
//  Created by Nikhil Tammanache on 05/11/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var vendorNameLabel: UILabel!
    @IBOutlet weak var vendorAddressLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    
    /// Use below function to configure collection view cell for Products.
    ///
    /// - Parameters:
    ///   - product: product details.
    ///   - indexPath: indexpath
    func configureCell(withProduct product: Product, andIndexPath indexPath: IndexPath) {
        productNameLabel.text = product.productName
        productPriceLabel.text = "Price: \(product.productPrice)"
        vendorNameLabel.text = product.vendorName
        vendorAddressLabel.text = product.vendorAddress
        addToCartButton.tag = indexPath.row
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
    }
}
