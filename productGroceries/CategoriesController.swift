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
    
    
    static var instance:CategoriesController! = nil
    
    
    override func viewDidLoad()
    {
        CategoriesController.instance = self
        
        super.viewDidLoad()
        
        tableView.dataSource        = self
        
        tableView.delegate          = self
        
        tableView.autoresizingMask  = [.FlexibleHeight, .FlexibleWidth]
        
        tableView.separatorStyle = .None

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
    

    
    
    
    func colorForCategoryIndex(index:Int) -> UIColor
    {
        if 0 <= index && index < categories.count {
            return UIColor(hue:(CGFloat(index)/CGFloat(categories.count)), saturation:0.3, brightness:1.0, alpha:1.0)
        }
        else {
            return UIColor.whiteColor()
        }
    }
    
    
    func colorForCategory(category:String) -> UIColor
    {
        if let index = categories.indexOf(category) {
            return colorForCategoryIndex(index)
        }
        else {
            return colorForCategoryIndex(-1)
        }
    }
    
    
    func colorForItem(item:Item,onRow:Int) -> UIColor {
        var hue:CGFloat = 0
        var saturation:CGFloat = 0
        var brightness:CGFloat = 0
        var alpha:CGFloat = 1
        
        let categoryColor = colorForCategory(item.category)
            
        categoryColor.getHue(&hue,saturation:&saturation,brightness:&brightness,alpha:&alpha)
        
        if 1 == onRow % 2 {
            return UIColor(hue:hue,saturation:0.1,brightness:1.0,alpha:1.0)
        }
        else {
            return UIColor(hue:hue,saturation:0.15,brightness:1.0,alpha:1.0)
        }
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
        
        // TODO PREFERENCES: SATURATION
        cell.backgroundColor    = colorForCategoryIndex(indexPath.row)
        
        if let label = cell.textLabel {
            label.text = categories[indexPath.row]
            
            var white:CGFloat = 0
            var alpha:CGFloat = 1
            
            cell.backgroundColor!.getWhite(&white,alpha:&alpha)
            
            // TODO PREFERENCES: LIGHT/DARK COLOR
            label.textColor = white < 0.5 ? UIColor.lightTextColor() : UIColor.darkTextColor()
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
            self.reload()
        case .Insert:
            add()
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let category = categories[indexPath.row]
        
        let items = ItemsController()
        
        items.colorOfCategory = colorForCategoryIndex(indexPath.row)
        
        items.category  = category
        items.items     = ItemsDataManager.allItemsInCategory(category)
        
        AppDelegate.navigator.pushViewController(items, animated:true)
    }
}


