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
//        result.backgroundColor      = UIColor.blackColor()
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
        
        if let label = cell.textLabel {
            label.text = item.name
            label.textColor = UIColor.grayColor()
        }
        
        cell.selectionStyle = .None
        
        switch item.value {
        case .Checkmark(let on):
        
            cell.accessoryType = on ? .Checkmark : .None

        case .Quantity(let count):
            
            let label = UILabel()
            
            label.frame             = CGRectMake(0,0,90,45)
            label.textColor         = UIColor.orangeColor()
            label.text              = String(count)
            label.textAlignment     = .Right
            
            cell.accessoryView      = label
//            cell.editingAccessoryView = label
            
        default:
            
            cell.accessoryType = .None
        }

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
    
    
}
