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
    var items:[Data.Item]                = []
    
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
            UIBarButtonItem(barButtonSystemItem:.Add, target:self, action: #selector(ItemsController.add))
//            editButtonItem(),
        ]
        
        navigationItem.rightBarButtonItems = items
        
        
        
        // "add gesture recognizer to determine which side of cell was tapped on"
        
        let recognizer = UITapGestureRecognizer(target:self, action:#selector(ItemsController.handleTap(_:)))
        
        recognizer.delegate = self
        
        tableView.addGestureRecognizer(recognizer)
    }
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    
    class func styleCell(cell:UITableViewCell,item:Data.Item,indexPath:NSIndexPath)
    {
        cell.selectedBackgroundView = UIView.createWithBackgroundColor(Data.Manager.settingsGetSelectionColor())
        
        do
        {
            var color = ControllerOfCategories.instance.colorForItem(item,onRow:indexPath.row)
            
            //            let rgba  = color.RGBA()
            
            let alpha = Data.Manager.settingsGetFloatForKey(indexPath.row.isEven ? .SettingsTabItemsRowEvenOpacity : .SettingsTabItemsRowOddOpacity, defaultValue:0.8)
            
            color = color.colorWithAlphaComponent(CGFloat(alpha))
            
            cell.backgroundColor = color
        }
        
        if let label = cell.textLabel {
            if Data.Manager.settingsGetBoolForKey(.SettingsTabItemsUppercase) {
                label.text = item.name.uppercaseString
            }
            else {
                label.text = item.name
            }
            label.textColor = Data.Manager.settingsGetItemsTextColor()
            label.font      = Data.Manager.settingsGetItemsFont()

            if Data.Manager.settingsGetBoolForKey(.SettingsTabItemsEmphasize) {
                label.font = label.font.fontWithSize(label.font.pointSize+1)
            }
        }
        
        cell.selectionStyle = .Default
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
        
        ItemsController.styleCell(cell,item:item,indexPath:indexPath)
        
        if 0 < item.quantity
        {
            let views = ControllerOfCategories.instance.styleQuantity(cell,indexPath:indexPath,quantity:item.quantity)
        }
        
        return cell
    }
    
    
    
    
    func reload()
    {
        items = Data.Manager.itemGetAllInCategory(category)
        
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
                Data.Manager.itemPut(Data.Item.create(name:text.trimmed(),category:self.category))
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
            Data.Manager.itemRemove(item)
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
                    item.quantity -= 1
                    update = true
                }
            }
            else {
                item.quantity += 1
                update = true
            }
            
            if update {
                Data.Manager.itemPut(item)
                items[indexPath.row] = item
                self.reload()
            }
        }
    }

    
    
    
    func scrollToItem(name:String)
    {
        var row = -1
        
        for (index,item) in items.enumerate() {
            if item.name == name {
                row = index
                break
            }
        }
        
        if 0 <= row {
            let path = NSIndexPath(forRow:row,inSection:0)
            
            tableView.scrollToRowAtIndexPath(path,atScrollPosition:.Middle,animated:true)
        }
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        reload()

        
        tableView.backgroundColor = Data.Manager.settingsGetBackgroundColor()
        

        Data.Manager.displayHelpPageForItems(self)

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
