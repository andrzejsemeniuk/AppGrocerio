//
//  SummaryController.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class FontNamePicker : UITableViewController
{
    var names:[String]  = []
    
    var selected:String = ""
    
    
    
    override func viewDidLoad()
    {
        tableView.dataSource    = self
        
        tableView.delegate      = self
        
        tableView.separatorStyle = .None

        names = UIFont.familyNames()
        
        reload()
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        // TODO clear data and reload table
    }
    
    
    
    
    
    override func numberOfSectionsInTableView   (tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView                     (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return names.count
    }
    
    override func tableView                     (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let name = names[indexPath.row]
        
        let cell = UITableViewCell(style:.Default,reuseIdentifier:nil)
        
        if let label = cell.textLabel {
            label.text          = name
//            label.textColor = UIColor.grayColor()
            label.font          = UIFont(name:name,size:UIFont.labelFontSize())
            label.textAlignment = .Left
        }
        
        cell.selectionStyle = .Default
        cell.accessoryType  = name == selected ? .Checkmark : .None
        
        return cell
    }
    
    
    
    
    func reload()
    {
        names = names.sort()
        
        tableView.reloadData()
    }
    
    
    
    override func viewWillAppear(animated: Bool)
    {
        reload()
        
        super.viewWillAppear(animated)
    }
    
    
    
    var update: (() -> ()) = {}
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selected = names[indexPath.row]
        
        reload()
        
        update()
    }
    
}
