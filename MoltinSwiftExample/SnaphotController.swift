//
//  SnaphotController.swift
//  MoltinSwiftExample
//
//  Created by Peter Balsamo on 6/29/16.
//  Copyright © 2016 Moltin. All rights reserved.
//

import UIKit
import Moltin
import SwiftSpinner


class SnaphotController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let celltitle1 = UIFont.systemFontOfSize(18, weight: UIFontWeightRegular)
    let cellsubtitle = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    
    @IBOutlet weak var tableView: UITableView!
    
    private var collections:NSMutableArray = NSMutableArray()
    private var advertisers:NSMutableArray = NSMutableArray()
    private var selectedCollectionDict:NSDictionary?
    private var selectedAdvertisersDict:NSDictionary?
    private let PRODUCTS_LIST_SEGUE_IDENTIFIER = "productsListSegue"
    

    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
        titleButton.setTitle("TheLight News", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = Font.navlabel
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Center
        titleButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: Selector(), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: Selector())
        let buttons:NSArray = [searchButton]
        self.navigationItem.rightBarButtonItems = buttons as? [UIBarButtonItem]
        
        self.refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.blackColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(SnaphotController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView!.addSubview(refreshControl)
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.estimatedRowHeight = 100
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.tableView!.backgroundColor = UIColor(white:0.90, alpha:1.0)
        self.tableView!.tableFooterView = UIView(frame: .zero)
        
        self.tableView?.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0)
        self.tableView?.scrollIndicatorInsets = UIEdgeInsetsMake(-44, 0, 0, 0)
        
        // Show loading UI
        SwiftSpinner.show("Loading Collections")
        
        // Get collections, async
        Moltin.sharedInstance().collection.listingWithParameters(nil, success: { (response) -> Void in
  
            SwiftSpinner.hide()
            self.collections = (response["result"] as? NSMutableArray)!
            self.tableView.reloadData()
            
        }) { (response, error) -> Void in
            SwiftSpinner.hide()
            AlertDialog.showAlert("Error", message: "Couldn't load collections", viewController: self)
            print("Something went wrong...")
            print(error)
        }
        
        Moltin.sharedInstance().product.listingWithParameters(["collection": "1284302377851028385", "limit": NSNumber(integer: 8), "offset": 0], success: { (response) -> Void in
            
            SwiftSpinner.hide()
            if let newProducts:NSArray = response["result"] as? NSArray {
                self.advertisers.addObjectsFromArray(newProducts as [AnyObject])
                
            }
            
            //let responseDictionary = response as NSDictionary
            
            self.tableView.reloadData()
            
        }) { (response, error) -> Void in
            // Something went wrong!
            SwiftSpinner.hide()
            
            AlertDialog.showAlert("Error", message: "Couldn't load products", viewController: self)
            
            print("Something went wrong...")
            print(error)
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        } else {
            self.navigationController?.navigationBar.barTintColor = UIColor(white:0.45, alpha:1.0)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - refresh
    
    func refreshData(sender:AnyObject) {
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let result:CGFloat = 243
        if (indexPath.section == 0) {
            
            switch (indexPath.row % 4)
            {
            case 0:
                return 44
            default:
                return result
            }
        } else if (indexPath.section == 1) {
            let result:CGFloat = 140
            switch (indexPath.row % 4)
            {
            case 0:
                return 44
            default:
                return result
            }
        }
        return 0
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            return 2
        }
        return 2
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.min
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomTableCell
        
        cell.collectionView?.delegate = nil
        cell.collectionView?.dataSource = nil
        cell.collectionView?.backgroundColor = UIColor.whiteColor()
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            cell.textLabel!.font = Font.cellheaderlabel
            cell.snaptitleLabel.font = cellsubtitle
            cell.snapdetailLabel.font = celltitle1
        } else {
            cell.textLabel!.font = Font.cellheaderlabel
            cell.snaptitleLabel.font = cellsubtitle
            cell.snapdetailLabel.font = celltitle1
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.textLabel?.text = ""
        
        cell.snaptitleLabel?.numberOfLines = 1
        cell.snaptitleLabel?.text = ""
        cell.snaptitleLabel?.textColor = UIColor.lightGrayColor()
        
        cell.snapdetailLabel?.numberOfLines = 3
        cell.snapdetailLabel?.text = ""
        cell.snapdetailLabel?.textColor = UIColor.blackColor()
        //cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel!.text = String(format: "%@", "Top News ")
                cell.selectionStyle = UITableViewCellSelectionStyle.Gray
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                return cell
                
            } else if (indexPath.row == 1) {
                
                cell.collectionView?.delegate = self
                cell.collectionView?.dataSource = self
                cell.collectionView?.tag = 0
                
                return cell
                
            } 
            
        } else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel!.text = "Shop by collection"
                
                return cell
                
            } else if (indexPath.row == 1) {
                
                cell.collectionView?.delegate = self
                cell.collectionView?.dataSource = self
                cell.collectionView?.tag = 1
                
                return cell
            }
            
        }
        return cell
    }
    
    
    // MARK: UICollectionView
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if (collectionView.tag == 0) {
            return CGSize(width: 375, height: 225)
        } else if (collectionView.tag == 1) {
            return CGSize(width: 130, height: 130)
        } 
        return CGSize(width: 120, height: 100)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if (collectionView.tag == 0) {
            return UIEdgeInsetsMake(-5,0,-10,0)
        } else if (collectionView.tag == 1) {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
        return UIEdgeInsetsMake(0, 0, 0, 0) // TLBR margin between cells
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section:Int)->Int
    {
        if (collectionView.tag == 0) {
                return advertisers.count
            
        } else if (collectionView.tag == 1) {
                return collections.count
        }
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath:NSIndexPath)->UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        
        let myLabel1:UILabel = UILabel(frame: CGRectMake(0, 110, cell.bounds.size.width, 20))
        myLabel1.backgroundColor = UIColor.whiteColor()
        myLabel1.textColor = UIColor.blackColor()
        myLabel1.textAlignment = NSTextAlignment.Center
        myLabel1.clipsToBounds = true
        //myLabel1.font = Font.headtitle
        cell.collectionImage!.backgroundColor = UIColor.whiteColor()
        if (collectionView.tag == 0) {
            
            cell.loadingSpinner!.hidden = false
            cell.loadingSpinner!.startAnimating()
            
            let row = indexPath.row
            let advertiserDictionary = advertisers.objectAtIndex(row) as? NSDictionary
            cell.setCollectionAdvertiser(advertiserDictionary!)
            
            cell.loadingSpinner!.stopAnimating()
            cell.loadingSpinner!.hidden = true
            
            return cell
            
        } else if (collectionView.tag == 1) {
            
            cell.loadingSpinner!.hidden = false
            cell.loadingSpinner!.startAnimating()
            
            let row = indexPath.row
            let collectionDictionary = collections.objectAtIndex(row) as? NSDictionary
            cell.setCollectionDictionary(collectionDictionary!)
            
            cell.loadingSpinner!.stopAnimating()
            cell.loadingSpinner!.hidden = true
            
            return cell
        }
        return cell
    }
    
    
    // MARK: - Segues
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if (collectionView.tag == 0) {
            

        } else if (collectionView.tag == 1) {
            
            selectedCollectionDict = collections.objectAtIndex(indexPath.row) as? NSDictionary
            
            performSegueWithIdentifier("snapshotSegue", sender: self)
        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "snapshotSegue" {
            
            /*
            let tabBarController = segue.destinationViewController as! UITabBarController;
            _ = tabBarController.viewControllers![0] as! ProductCollectionController // or whatever tab index you're trying to access
            //destinationViewController.property = "some value" */
            
            let newViewController = segue.destinationViewController as! ProductCollectionController
            newViewController.title = selectedCollectionDict!.valueForKey("title") as? String
            newViewController.collectionId = selectedCollectionDict!.valueForKeyPath("id") as? String
            //tabBarController?.selectedIndex = 2
        }
    }
    
}

//-----------------------end------------------------------
