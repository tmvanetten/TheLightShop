//
//  ProductListTableViewController.swift
//  MoltinSwiftExample
//
//  Created by Dylan McKee on 16/08/2015.
//  Copyright (c) 2015 Moltin. All rights reserved.
//

import UIKit
import Moltin
import SwiftSpinner

class ProductCollectionController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var shopLogo: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    //@IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    var multiplier: CGFloat = 1

    
    private let CELL_REUSE_IDENTIFIER = "ProductCell"
    
    private let LOAD_MORE_CELL_IDENTIFIER = "ProductsLoadMoreCell"
    
    private let PRODUCT_DETAIL_VIEW_SEGUE_IDENTIFIER = "productDetailSegue"
    
    private var products:NSMutableArray = NSMutableArray()
    
    private var paginationOffset:Int = 0
    
    private var showLoadMore:Bool = true
    
    private let PAGINATION_LIMIT:Int = 8
    
    private var selectedProductDict:NSDictionary?
    
    var collectionId:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadProducts(true)
        
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    
    private func loadProducts(showLoadingAnimation: Bool){
        
        assert(collectionId != nil, "Collection ID is required!")
        print(collectionId)
        // Load in the next set of products...
        
        // Show loading if neccesary?
        if showLoadingAnimation {
            SwiftSpinner.show("Loading products")
        }
        
        Moltin.sharedInstance().product.listingWithParameters(["collection": collectionId!, "limit": NSNumber(integer: PAGINATION_LIMIT), "offset": paginationOffset], success: { (response) -> Void in
            // Let's use this response!
            SwiftSpinner.hide()
            
            if let newProducts:NSArray = response["result"] as? NSArray {
                self.products.addObjectsFromArray(newProducts as [AnyObject])
                
            }
            
            
            let responseDictionary = response as NSDictionary
            
            if let newOffset:NSNumber = responseDictionary.valueForKeyPath("pagination.offsets.next") as? NSNumber {
                self.paginationOffset = newOffset.integerValue
                
            }
            
            if let totalProducts:NSNumber = responseDictionary.valueForKeyPath("pagination.total") as? NSNumber {
                // If we have all the products already, don't show the 'load more' button!
                if totalProducts.integerValue >= self.products.count {
                    self.showLoadMore = false
                }
                
            }
            
            self.collectionView.reloadData()
            
        }) { (response, error) -> Void in
            // Something went wrong!
            SwiftSpinner.hide()
            
            AlertDialog.showAlert("Error", message: "Couldn't load products", viewController: self)

            print("Something went wrong...")
            print(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Button
     
    @IBAction func addToShoppingCart(sender: UIButton)
    {
    
    }
    
    
    
    // MARK: UICollectionDataSource

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        if showLoadMore {
            return (products.count + 1)
        }
        
        return products.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        if (showLoadMore && indexPath.row > (products.count - 1)) {
            // it's the last item - show a 'Load more' cell for pagination instead.
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_REUSE_IDENTIFIER, forIndexPath: indexPath) as! CollectionViewCell
            
            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_REUSE_IDENTIFIER, forIndexPath: indexPath) as! CollectionViewCell
        
        let row = indexPath.row
        
        let product:NSDictionary = products.objectAtIndex(row) as! NSDictionary
        
        cell.configureWithProduct(product)
        
        return cell
    }
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let cellWidth = self.view.frame.size.width/2
        return CGSizeMake(cellWidth, 190 * multiplier)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 0
    }
    
    /*
    func adjustForBiggerScreen()
    {
        for constraint in shopLogo.constraints
        {
            constraint.constant *= multiplier
        }
        
        for constraint in shopName.constraints
        {
            constraint.constant *= multiplier
        }
        
        headerHeightConstraint.constant *= multiplier
        //buttonsStackViewHeightConstraint.constant *= multiplier
        
        var fontSize = 25.0 * multiplier
        shopName.font =  UIFont(name: "HelveticaNeue", size: fontSize)
        
        fontSize = 17.0 * multiplier
        //signOutButton.titleLabel!.font =  UIFont(name: "HelveticaNeue-Bold", size: fontSize)
        
        //shoppingCartButton.imageEdgeInsets = UIEdgeInsetsMake(10 * multiplier, 64 * multiplier, 10 * multiplier, 64 * multiplier)
    }
    
    //var searchingMore = false
    //var hasMoreToShow = true
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if collectionView.contentOffset.y >= (collectionView.contentSize.height - collectionView.bounds.size.height)
        { /*
            if (searchingMore == false) && hasMoreToShow
            {
                searchingMore = true
                //backend.offset += 6
                //retrieveProducts()
            } */
        }
    } */

    
    // MARK: - Segues
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if (showLoadMore && indexPath.row > (products.count - 1)) {
            // Load more products!
            loadProducts(false)
            return
        }
        
        // Push a product detail view controller for the selected product.
        let product:NSDictionary = products.objectAtIndex(indexPath.row) as! NSDictionary
        selectedProductDict = product
        
        performSegueWithIdentifier(PRODUCT_DETAIL_VIEW_SEGUE_IDENTIFIER, sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == PRODUCT_DETAIL_VIEW_SEGUE_IDENTIFIER {
            // Set up product detail view
            let newViewController = segue.destinationViewController as! ProductDetailViewController
            
            newViewController.title = selectedProductDict!.valueForKey("title") as? String
            newViewController.productDict = selectedProductDict
        }
    }
    
}
