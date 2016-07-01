//
//  CollectionsViewController.swift
//  MoltinSwiftExample
//
//  Created by Dylan McKee on 15/08/2015.
//  Copyright (c) 2015 Moltin. All rights reserved.
//

import UIKit
import Moltin
import SwiftSpinner

class CollectionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView:UITableView?
    
    private var collections:NSArray?
    
    private let COLLECTION_CELL_REUSE_IDENTIFIER = "CollectionCell"
    
    private let PRODUCTS_LIST_SEGUE_IDENTIFIER = "productsListSegue"
    
    private var selectedCollectionDict:NSDictionary?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.title = "Collections"
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.backgroundColor = Color.tablebackColor
        self.tableView!.tableFooterView = UIView(frame: .zero)
        self.tableView?.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        self.tableView?.scrollIndicatorInsets = UIEdgeInsetsMake(-20, 0, 0, 0)
        
        // Show loading UI
        SwiftSpinner.show("Loading Collections")

        Moltin.sharedInstance().collection.listingWithParameters(["status": NSNumber(int: 1), "limit": NSNumber(int: 20)], success: { (response) -> Void in

            SwiftSpinner.hide()
            self.collections = response["result"] as? NSArray
            self.tableView?.reloadData()
    
        }) { (response, error) -> Void in
            
            SwiftSpinner.hide()
            AlertDialog.showAlert("Error", message: "Couldn't load collections", viewController: self)
            print("Something went wrong...")
            print(error)
        }
        
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    
    // MARK: - TableView Data source & Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collections != nil {
            return collections!.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(COLLECTION_CELL_REUSE_IDENTIFIER, forIndexPath: indexPath) as! CustomTableCell
        
        let row = indexPath.row
        
        let collectionDictionary = collections?.objectAtIndex(row) as! NSDictionary
        
        cell.setCollectionDictionary(collectionDictionary)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedCollectionDict = collections?.objectAtIndex(indexPath.row) as? NSDictionary

        performSegueWithIdentifier(PRODUCTS_LIST_SEGUE_IDENTIFIER, sender: self)

        
    }
    
    func tableView(_tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
        
            if cell.respondsToSelector(Selector("setSeparatorInset:")) {
                cell.separatorInset = UIEdgeInsetsZero
            }
            if cell.respondsToSelector(Selector("setLayoutMargins:")) {
                cell.layoutMargins = UIEdgeInsetsZero
            }
            if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
                cell.preservesSuperviewLayoutMargins = false
            }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == PRODUCTS_LIST_SEGUE_IDENTIFIER {
            // Set up products list view!
            let newViewController = segue.destinationViewController as! ProductCollectionController
            
            newViewController.title = selectedCollectionDict!.valueForKey("title") as? String
            newViewController.collectionId = selectedCollectionDict!.valueForKeyPath("id") as? String
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

