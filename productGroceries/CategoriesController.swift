//
//  CategoriesController.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class CategoriesController : UITableViewController {
    
    var categories:[String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource        = self
        
        tableView.delegate          = self
        
        tableView.autoresizingMask  = [.FlexibleHeight, .FlexibleWidth]
        
        // TODO CREATE REUSABLE CELL
        
        var items = navigationItem.rightBarButtonItems
        
        if items == nil {
            items = [UIBarButtonItem]()
        }
        
        items! += [
            UIBarButtonItem(barButtonSystemItem:.Add, target:self, action: "add"),
            editButtonItem(),
        ]
        
        navigationItem.rightBarButtonItems = items

        
        categories                  = ItemsDataManager.allCategories()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        // categories = []
        // tableView.reloadData()
    }
    
    
    
    
    
    override func numberOfSectionsInTableView   (tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView                     (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    override func tableView                     (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style:.Default,reuseIdentifier:nil)
        
        if let label = cell.textLabel {
            label.text = categories[indexPath.row]
        }
        
        cell.selectionStyle     = UITableViewCellSelectionStyle.Default
        
        cell.accessoryType      = .DisclosureIndicator
        
        return cell
    }

    
    
    func reload()
    {
        categories = ItemsDataManager.allCategories()
        tableView.reloadData()
    }
    
    
    
    // NOTE: THIS METHOD IS REFERENCED IN APPDELEGTE 
    
    func add()
    {
        let alert = UIAlertController(title:"Add a new Category", message:"Specify new category name:", preferredStyle:.Alert)
        
        alert.addTextFieldWithConfigurationHandler() {
            field in
        }
        
        let actionAdd = UIAlertAction(title:"Add", style:.Default, handler: {
            action in
            
            if let fields = alert.textFields, text = fields[0].text {
                if ItemsDataManager.addCategory(text) {
                    self.reload()
                }
            }
        })
        
        let actionCancel = UIAlertAction(title:"Cancel", style:.Cancel, handler: {
            action in
        })
        
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        
        AppDelegate.rootViewController.presentViewController(alert, animated:true, completion: {
            print("completed showing add alert")
        })
    }
    
    
    // NOTE: THIS IS A TABLE-DATA-SOURCE-DELEGATE METHOD
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        switch editingStyle
        {
        case .None:
            print("None")
        case .Delete:
            let category = categories[indexPath.row]
            ItemsDataManager.removeCategory(category)
            categories.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Left)
        case .Insert:
            add()
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let category = categories[indexPath.row]
        
        let items = ItemsController()
        
        items.category  = category
        items.items     = ItemsDataManager.allItemsInCategory(category)
        
        AppDelegate.navigator.pushViewController(items, animated:true)
    }
}


