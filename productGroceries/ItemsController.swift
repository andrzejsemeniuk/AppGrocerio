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
    
    var category:String
    
    
    init(category:String)
    {
        super.init()
        
        self.category = category
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource    = self
        
        tableView.delegate      = self
        
        items                   = ItemsDataManager.allItemsInCategory(category)
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
        let cell = UITableViewCell(style:.Default,reuseIdentifier:nil)
        
        if let label = cell.textLabel {
            label.text = items[indexPath.row].name
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        
        return cell
    }

    
}