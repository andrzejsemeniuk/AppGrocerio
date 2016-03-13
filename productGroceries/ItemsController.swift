//
//  ItemsController.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class ItemsController : UITableViewController
{
    var items:[Item] = []
    
    var category:String = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource    = self
        
        tableView.delegate      = self
        
        
        var items = navigationItem.rightBarButtonItems
        
        if items == nil {
            items = [UIBarButtonItem]()
        }
        
        items! += [
            UIBarButtonItem(barButtonSystemItem:.Add, target:self, action: "add"),
            editButtonItem(),
        ]
        
        navigationItem.rightBarButtonItems = items
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    override func numberOfSectionsInTableView   (tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView                     (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    override func tableView                     (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let item = items[indexPath.row]
        
        let cell = UITableViewCell(style:.Default,reuseIdentifier:nil)
        
        if let label = cell.textLabel {
            label.text = item.name
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.Default;
        
        switch item.value {
        case .Checkmark(let on):
            cell.accessoryType = on ? .Checkmark : .None
        case .Quantity(let count):
            
            let button = UIButton(type:.ContactAdd)
            button.tag = indexPath.row
            button.setTitle(String(count), forState:.Normal)
            button.addTarget(self, action:"pressedAddInCell:", forControlEvents:.TouchUpInside)
            cell.accessoryView = button

            
        default:
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    
    func pressedAddInCell(sender: UIButton!) {
        print("pressed + on cell=\(items[sender.tag].name)")
    }
    
    
    
    func reload()
    {
        items = ItemsDataManager.allItemsInCategory(category)
        tableView.reloadData()
    }
    
    
    
    func add()
    {
        let alert = UIAlertController(title:"Add a new item", message:"Specify new item name:", preferredStyle:.Alert)
        
        alert.addTextFieldWithConfigurationHandler() {
            field in
            // called to configure text field before displayed
        }
        
        let actionAdd = UIAlertAction(title:"Add", style:.Default, handler: {
            action in
            
            if let fields = alert.textFields, text = fields[0].text {
                ItemsDataManager.putItem(Item(name:text.trimmed(),category:self.category,value:Item.Value.Checkmark(on:false)))
                self.reload()
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
            let item = items[indexPath.row]
            ItemsDataManager.removeItem(item)
            items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Left)
        case .Insert:
            add()
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var item = items[indexPath.row]
        
        switch item.value {
        case .Checkmark(let on):
            item.value = .Checkmark(on:!on)
            ItemsDataManager.putItem(item)
            items[indexPath.row] = item
        case .Quantity(let count):
            item.value = .Quantity(count:1+count)
            ItemsDataManager.putItem(item)
            items[indexPath.row] = item
        default:
            ()
        }
    }
    
}
