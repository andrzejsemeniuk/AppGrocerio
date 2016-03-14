//
//  SummaryController.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class SummaryController : UITableViewController
{
    var items = [[Item]]()
    
    var lastTap:UITableViewTap!
    
    override func viewDidLoad()
    {
        tableView.dataSource    = self
        
        tableView.delegate      = self
        
        reload(false)
        
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        // TODO clear data and reload table
    }
    
    
    
    
    
    override func numberOfSectionsInTableView   (tableView: UITableView) -> Int
    {
        return items.count
    }
    
    override func tableView                     (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items[section].count
    }
    
    override func tableView                     (tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let result                  = UILabel()
        
        result.text                 = items[section][0].category
        result.textAlignment        = .Center
//        result.font                 = UIFont.systemFontOfSize(12, weight:2.0)
        result.backgroundColor      = CategoriesController.instance.colorForCategory(result.text!)
//        result.textColor            = UIColor.whiteColor()
        
        return result
    }
    
    override func tableView                     (tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50 //self.tableView(tableView, viewForHeaderInSection:section)!.bounds.height
    }
    
    override func tableView                     (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let item = items[indexPath.section][indexPath.row]
        
        let cell = UITableViewCell(style:.Default,reuseIdentifier:nil)
        
        cell.backgroundColor = CategoriesController.instance.colorForItem(item,onRow:indexPath.row)
        
        if let label = cell.textLabel {
            label.text = item.presentableName()
            label.textColor = UIColor.grayColor()
        }
        
        cell.selectionStyle = .None
        
        let label = UILabel()
        
        label.frame             = CGRectMake(0,0,90,45)
//        label.textColor         = UIColor.orangeColor()
        label.text              = String(item.quantity)
        label.textAlignment     = .Right
        
        cell.accessoryView      = label
        cell.editingAccessoryView = label

        return cell
    }
    
    
    
    
    func reload(updateTable:Bool = true)
    {
        items = ItemsDataManager.summary()

        if updateTable {
            tableView.reloadData()
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool)
    {
        reload(true)
        
        super.viewWillAppear(animated)
    }

    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            let section     = indexPath.section
            let row         = indexPath.row
            let item        = items[section][row]
            ItemsDataManager.resetItem(item)
            items[section].removeAtIndex(row)
            if items[section].count < 1 {
                items.removeAtIndex(section)
            }
            reload(true)

        }
    }
    
}
