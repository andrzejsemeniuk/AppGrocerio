//
//  SummaryController.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class ColorPicker : UITableViewController
{
    var colors:[UIColor]  = []
    
    var selected:UIColor = UIColor.blackColor()
    
    
    
    override func viewDidLoad()
    {
        tableView.dataSource    = self
        
        tableView.delegate      = self
        
        tableView.separatorStyle = .None

        colors = [
            UIColor.GRAY(0.75,1),
            UIColor.GRAY(0.50,1),
            UIColor.GRAY(0.25,1),
        ]
        
        let values:[Float] = [0,0.6,0.8,1]
        
        for g in values {
            for r in values {
                for b in values {
                    colors.append(UIColor.RGBA(r,g,b,1))
                }
            }
        }
        
        
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
        return colors.count
    }
    
    override func tableView                     (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let color = colors[indexPath.row]
        
        let cell = UITableViewCell(style:.Default,reuseIdentifier:nil)
        
        cell.backgroundColor = color
        
        cell.selectionStyle = .Default
        
        if color == selected {
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    
    
    
    func reload()
    {
        tableView.reloadData()
    }
    
    
    
    override func viewWillAppear(animated: Bool)
    {
        reload()
        
        if let row = colors.indexOf(selected) {
            let path = NSIndexPath(forRow:row,inSection:0)
            tableView.scrollToRowAtIndexPath(path,atScrollPosition:.Middle,animated:true)
        }
        
        super.viewWillAppear(animated)
    }
    
    
    
    var update: (() -> ()) = {}
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selected = colors[indexPath.row]
        
        reload()
        
        update()
    }
    
}
