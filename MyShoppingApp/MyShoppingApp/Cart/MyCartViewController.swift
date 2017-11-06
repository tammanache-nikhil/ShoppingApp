//
//  MyCartViewController.swift
//  ShoppingApp
//
//  Created by Pfizer on 06/11/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import UIKit

class MyCartViewController: UIViewController {

    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    //The lazy image object
    lazy var lazyImage:LazyImage = LazyImage()
    var myCartProducts = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.estimatedRowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func refreshView() {
        let dataManager = DatabaseManager.shared
        if let products = dataManager.fetchObjects(ofType: Product.stringName, inContext: dataManager.mainContext, withPredicate: NSPredicate(format: "isAddedToCart = 1"), andSortDescriptor: [NSSortDescriptor(key: "productName", ascending: true)]) as? [Product] {
            myCartProducts = products
            totalPriceOfCart()
            self.cartTableView.reloadData()
        }
    }
    
    @IBAction func onTapCallVendor(_ sender: UIButton) {
        let product = myCartProducts[sender.tag]
        guard let phoneNumber = product.phoneNumber, let number = URL(string: "tel://" + phoneNumber) else {
            return
        }
        UIApplication.shared.canOpenURL(number)
    }
    
    @IBAction func removeCartTap(_ sender: UIButton) {
        let product = myCartProducts[sender.tag]
        product.updateAddToCart(withValue: false)
        refreshView()
        showPopup()
    }
    
    /// Use below method to success or error popup.
    ///
    /// - Parameter isAddedSuccessfully: boolean to indicate success or failure.
    private func showPopup() {
        let message = "Product removed from Cart."
        self.showAlert(title: "MyShoppingApp", message: message, completion: nil)
    }
    
    /// Use below function to get total price of all products added in cart.
    private func totalPriceOfCart() {
        var sum: Int64 = 0
        for product in myCartProducts {
          sum += product.productPrice
        }
        totalPriceLabel.text = "Total Price: \(sum)"
    }
}

extension MyCartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartTableViewCell {
            let product = myCartProducts[indexPath.row]
            cell.configureCell(withProduct: product, andIndexPath: indexPath)
            lazyImage.show(imageView: cell.productImageView, url: product.imageURL, defaultImage: "placeHolder")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
