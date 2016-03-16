//
//  ItemsController.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class ItemsController : UITableViewController, UIGestureRecognizerDelegate
{
    var items:[Item]                = []
    
    var category:String             = ""
    
    var colorOfCategory:UIColor     = UIColor.whiteColor()
    
    var lastTap:UITableViewTap!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource    = self
        
        tableView.delegate      = self
        
        
        tableView.separatorStyle = .None

        
        var items = navigationItem.rightBarButtonItems
        
        if items == nil {
            items = [UIBarButtonItem]()
        }
        
        items! += [
            UIBarButtonItem(barButtonSystemItem:.Add, target:self, action: "add"),
//            editButtonItem(),
        ]
        
        navigationItem.rightBarButtonItems = items
        
        
        
        // "add gesture recognizer to determine which side of cell was tapped on"
        
        let recognizer = UITapGestureRecognizer(target:self, action:"handleTap:")
        
        recognizer.delegate = self
        
        tableView.addGestureRecognizer(recognizer)
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
        
        do
        {
            let isEven = indexPath.row % 2 == 0
            
            var color = CategoriesController.instance.colorForItem(item,onRow:indexPath.row)
            
            let rgba  = color.rgba()
            
            let alpha = ItemsDataManager.settingsGetFloatForKey(isEven ? .SettingsTabItemsRowEvenTransparency : .SettingsTabItemsRowOddTransparency, defaultValue:rgba.alpha)
            
            color = color.colorWithAlphaComponent(CGFloat(alpha))
                
            cell.backgroundColor = color
        }
        
        if let label = cell.textLabel {
            label.text = item.name
            label.textColor = UIColor.grayColor()
        }
        
        cell.selectionStyle = .Default
        
        if 0 < item.quantity {
            do
            {
                let fill = UIView()
                
                fill.frame                  = CGRectMake(0,0,cell.bounds.height*1.2,cell.bounds.height)
                fill.frame.origin.x         = cell.bounds.width-fill.frame.size.width
                fill.backgroundColor        = UIColor(red:0.6,green:0.6,blue:0.6,alpha:0.60)
                
                cell.addSubview(fill)
            }
            
            do
            {
                let label = UILabel()
                
                label.frame                 = CGRectMake(0,0,cell.bounds.height*2,cell.bounds.height)
                label.textColor             = UIColor.whiteColor()
                label.text                  = String(item.quantity)
                label.textAlignment         = .Right
                
                cell.accessoryView          = label
                cell.editingAccessoryView   = label
            }
        }
        
        return cell
    }
    
    
    
    
    func reload()
    {
        items = ItemsDataManager.allItemsInCategory(category)
        
        self.title = category

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
                ItemsDataManager.putItem(Item.create(name:text.trimmed(),category:self.category))
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
        
        if lastTap.path == indexPath {
            var update = false
            
            if lastTap.point.x < tableView.bounds.width/2 {
                if 0 < item.quantity {
                    item.quantity--
                    update = true
                }
            }
            else {
                item.quantity++
                update = true
            }
            
            if update {
                ItemsDataManager.putItem(item)
                items[indexPath.row] = item
                self.reload()
            }
        }
    }

    
    
    
    override func viewWillAppear(animated: Bool)
    {
        reload()
        
        ItemsDataManager.displayHelpPageForItems(self)

        super.viewWillAppear(animated)
    }
    

    
    
    
    func gestureRecognizerShouldBegin(recognizer: UIGestureRecognizer) -> Bool
    {
        let point = recognizer.locationInView(tableView)
        
        if let path = tableView.indexPathForRowAtPoint(point)
        {
            lastTap = UITableViewTap(path:path, point:point)
        }
        
        return false
    }
    

    func handleTap(recognizer:UIGestureRecognizer)
    {
        // unused - we're not interested
    }
    
 
    
}
