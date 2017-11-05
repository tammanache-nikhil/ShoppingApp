//
//  ProductListViewController.swift
//  MyShoppingApp
//
//  Created by Nikhil Tammanache on 05/11/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var allProducts = [Product]()
    //The lazy image object
    lazy var lazyImage:LazyImage = LazyImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshUI()
        fetchAllProductsFromServer()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchAllProductsFromServer() {
        let request = URLRequestManager(requestType: .getAllProducts, urlString: "https://mobiletest-hackathon.herokuapp.com/getdata/", requestHTTPMethod: .kHTTPGet, operationPriority: .kPriorityHigh)
        NetworkManager.defaultManager.addRequestTask(requestTask: request, success: { [weak self] (responseData, requestManager) in
            if let allProductsData = responseData as? [String : Any], let allProducts = allProductsData[PayloadKeys.products] as? [[String : Any]], allProducts.count > 0 {
                //Save in DB
                let context = DatabaseManager.shared.mainContext
                context.performAndWait {
                    for productPayload in allProducts {
                        Product.createOrUpdate(inContext: context, withPayload: productPayload)
                    }
                    DatabaseManager.shared.saveContext()
                    
                    DispatchQueue.main.async {
                        self?.refreshUI()
                    }
                }
            }
        }) { _ in
            
        }
    }
    
    private func refreshUI() {
        let dataManager = DatabaseManager.shared
        if let products = dataManager.fetchObjects(ofType: Product.stringName, inContext: dataManager.mainContext, withPredicate: nil, andSortDescriptor: [NSSortDescriptor(key: "productName", ascending: true)]) as? [Product] {
            allProducts = products
            self.productCollectionView.reloadData()
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     
     */
    @IBAction func addToCartTap(_ sender: UIButton) {
        let product = allProducts[sender.tag]
        product.updateAddToCart(withValue: true)
        DatabaseManager.shared.saveContext()
    }
}

extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /**
     collectionView numberOfSections datasource method
     */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
     collectionView numberOfItemsInSection datasource method
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailCell", for: indexPath) as? ProductCollectionViewCell {
            let product = allProducts[indexPath.row]
            cell.configureCell(withProduct: product, andIndexPath: indexPath)
            lazyImage.show(imageView: cell.productImageView, url: product.imageURL, defaultImage: "placeHolder")
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    // MARK: Collection view layout
    /**
     collectionView layout datasource method
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.width/2)-40
        return CGSize(width: width, height: 220)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}
