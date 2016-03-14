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
    var items:[Item] = []
    
    var category:String = ""
    
    var colorOfCategory:UIColor = UIColor.whiteColor()
    
    var lastTap:LastTap!
    
    
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
            editButtonItem(),
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
            var hue:CGFloat = 0
            var saturation:CGFloat = 0
            var brightness:CGFloat = 0
            var alpha:CGFloat = 1
            
            colorOfCategory.getHue(&hue,saturation:&saturation,brightness:&brightness,alpha:&alpha)
            
            if 0 == indexPath.row % 2 {
                cell.backgroundColor = UIColor(hue:hue,saturation:0.1,brightness:1.0,alpha:1.0)
            }
            else {
                cell.backgroundColor = UIColor(hue:hue,saturation:0.15,brightness:1.0,alpha:1.0)
            }
        }
        
        if let label = cell.textLabel {
            var text = item.name
            if 33 < text.length {
                text = text.substring(to:30) + "..."
            }
            label.text = text
        }
        
        cell.selectionStyle = .Default
        
        switch item.value {
        case .Checkmark(let on):
            cell.accessoryType = on ? .Checkmark : .None
        case .Quantity(let count):
            
            if 0 < count {
                let label = UILabel()
                
                label.frame             = CGRectMake(0,0,120,45)
                //            label.textColor         = UIColor.orangeColor()
                label.text              = String(count)
                label.textAlignment     = .Right
                
                cell.accessoryView      = label
                cell.editingAccessoryView = label
            }
            
        default:
            cell.accessoryType = .None
        }
        
        return cell
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
            self.reload()
            
        case .Quantity(let count):
            
            if lastTap.path == indexPath {
                var update = false
                
                if lastTap.point.x < tableView.bounds.width/2 {
                    if 0 < count {
                        item.value = .Quantity(count:count-1)
                        update = true
                    }
                }
                else {
                    item.value = .Quantity(count:1+count)
                    update = true
                }
                
                if update {
                    ItemsDataManager.putItem(item)
                    items[indexPath.row] = item
                    self.reload()
                }
            }
            
        default:
            ()
        }
    }

    
    
    
    override func viewWillAppear(animated: Bool)
    {
        reload()
        
        super.viewWillAppear(animated)
    }
    

    
    
    
    func gestureRecognizerShouldBegin(recognizer: UIGestureRecognizer) -> Bool
    {
        let point = recognizer.locationInView(tableView)
        
        if let path = tableView.indexPathForRowAtPoint(point)
        {
            lastTap = LastTap(path:path, point:point)
        }
        
        return false
    }
    

    func handleTap(recognizer:UIGestureRecognizer)
    {
        // unused - we're not interested
    }
    
    
}
