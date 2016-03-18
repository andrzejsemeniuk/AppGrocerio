//
//  ItemsController.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class GenericListController : UITableViewController
{
    var items:[String]          = []
    
    var selected:String!        = nil
    
    var handlerForCellForRowAtIndexPath:((controller:GenericListController,indexPath:NSIndexPath) -> UITableViewCell)! = nil

    var handlerForDidSelectRowAtIndexPath:((controller:GenericListController,indexPath:NSIndexPath) -> Void)! = nil
    
    var handlerForCommitEditingStyle:((controller:GenericListController,commitEditingStyle:UITableViewCellEditingStyle,indexPath:NSIndexPath) -> Bool)! = nil

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource        = self
        
        tableView.delegate          = self
        
//        tableView.separatorStyle    = .None
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
        if handlerForCellForRowAtIndexPath != nil {
            return handlerForCellForRowAtIndexPath(controller:self,indexPath:indexPath)
        }
        
        let name = items[indexPath.row]
        
        let cell = UITableViewCell(style:.Default,reuseIdentifier:nil)
        
        if let label = cell.textLabel {
            label.text = name
        }
        
        cell.selectionStyle = .Default
        
        if selected != nil && selected == name {
            cell.accessoryType = .Checkmark
        }
        
        return cell
    }
    
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if handlerForDidSelectRowAtIndexPath != nil {
            handlerForDidSelectRowAtIndexPath(controller:self,indexPath:indexPath)
        }
    }

    
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if handlerForCommitEditingStyle != nil {
            if handlerForCommitEditingStyle(controller:self,commitEditingStyle:editingStyle,indexPath:indexPath) {
                switch editingStyle
                {
                case .None:
                    print("None")
                case .Delete:
                    items.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Left)
                case .Insert:
                    print("Add")
                }

            }
        }
    }

    
    
    
    
    override func viewWillAppear(animated: Bool)
    {
        tableView.reloadData()
        
        super.viewWillAppear(animated)
    }
    

    
    
    
 
    
}
