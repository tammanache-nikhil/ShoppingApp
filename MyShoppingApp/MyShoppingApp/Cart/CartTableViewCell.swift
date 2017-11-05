//
//  CartTableViewCell.swift
//  ShoppingApp
//
//  Created by Pfizer on 06/11/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var removeFromCartButton: UIButton!
    @IBOutlet weak var callVendorButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var vendorNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var vendorAddressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(withProduct product: Product, andIndexPath indexPath: IndexPath) {
        productNameLabel.text = product.productName
        productPriceLabel.text = "\(product.productPrice)"
        vendorNameLabel.text = product.vendorName
        vendorAddressLabel.text = product.vendorAddress
        removeFromCartButton.tag = indexPath.row
        callVendorButton.tag = indexPath.row
    }

}
