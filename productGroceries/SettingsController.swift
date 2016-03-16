//
//  SettingsController.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class SettingsController : UITableViewController
{
    
    override func viewDidLoad()
    {
        tableView               = UITableView(frame:tableView.frame,style:.Grouped)
        
        tableView.dataSource    = self
        
        tableView.delegate      = self
        
        
        tableView.separatorStyle = .None
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    // data
    //  reset [confirm]
    //  clear [confirm] // also, have clear in summary?
    //  save [alert]
    //  load >
    
    // settings
    //  save [alert]
    //  load >
    
    // categories
    //   sample
    //  font? // tap prev/next
    //  Uppercase?
    //  bold?
    //  colors >
    //   custom
    //   solid
    //   plain
    //   gray
    //   strawberry
    //   saturation [----]
    
    // items
    //  odd alpha <-> // slider
    //  even alpha <-> // slider
    //  quantity
    //   bg-color // sliders
    //   font-color //
    //   font?
    
    // summary
    //  quantity
    //   bg-color
    //    match items?
    //   font-color
    //    match items?
    
    
    
    private var updates:[() -> ()] = []
    
    func addUpdate(f:()->()) {
        updates.append(f)
    }
    
    
    
    typealias FunctionOnCell = (cell:UITableViewCell) -> ()
    
    var rows:[[Any]] = []
    
    
    
    
    override func numberOfSectionsInTableView   (tableView: UITableView) -> Int
    {
        return rows.count
    }
    
    override func tableView                     (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return rows[section].count-2
    }
    
    override func tableView                     (tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if let text = rows[section].first as? String {
            return 0 < text.length ? text : nil
        }
        return nil
    }
    
    override func tableView                     (tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        if let text = rows[section].last as? String {
            return 0 < text.length ? text : nil
        }
        return nil
    }
    
    override func tableView                     (tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int
    {
        if 0 < indexPath.row {
            //            return 1
        }
        return 0
    }
    
    override func tableView                     (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style:.Default,reuseIdentifier:nil)
        
        cell.selectionStyle = .None
        
        if let f = rows[indexPath.section][indexPath.row+1] as? FunctionOnCell {
            f(cell:cell)
        }
        
        return cell
    }
    
    
    
    
    
    
    
    
    func reload()
    {
        tableView.reloadData()
    }
    
    
    
    
    override func viewWillAppear(animated: Bool)
    {
        rows =
            [
                [
                    "SETTINGS",
                    { (cell:UITableViewCell) in
                        if let label = cell.textLabel {
                            label.text          = "Save"
                            cell.selectionStyle = .Default
                        }
                    },
                    { (cell:UITableViewCell) in
                        if let label = cell.textLabel {
                            label.text          = "Load"
                            cell.selectionStyle = .Default
                            cell.accessoryType  = .DisclosureIndicator
                        }
                    },
                    "Save current settings, or load previously saved settings"
                ],
                [
                    "CATEGORIES",
                    { (cell:UITableViewCell) in
                        if let label = cell.textLabel {
                            label.text          = "Font"
                            cell.selectionStyle = .Default
                            cell.accessoryType  = .DisclosureIndicator
                        }
                    },
                    { (cell:UITableViewCell) in
                        if let label = cell.textLabel {
                            cell.selectionStyle = .Default
                            label.text          = "Uppercase"
                            if true
                            {
                                let view = UISwitch()
                                view.setOn(ItemsDataManager.settingsGetBoolForKey(.SettingsTabCategoriesUppercase), animated:true)
                                self.addUpdate({
                                    ItemsDataManager.settingsSetBool(view.on, forKey:.SettingsTabCategoriesUppercase)
                                })
                                cell.accessoryView = view
                            }
                        }
                    },
                    { (cell:UITableViewCell) in
                        if let label = cell.textLabel {
                            cell.selectionStyle = .Default
                            label.text          = "Emphasize"
                            if true
                            {
                                let view = UISwitch()
                                view.setOn(ItemsDataManager.settingsGetBoolForKey(.SettingsTabCategoriesEmphasize), animated:true)
                                self.addUpdate({
                                    ItemsDataManager.settingsSetBool(view.on, forKey:.SettingsTabCategoriesEmphasize)
                                })
                                cell.accessoryView = view
                            }
                        }
                    },
                    { (cell:UITableViewCell) in
                        if let label = cell.textLabel {
                            label.text          = "Colors"
                            cell.accessoryType  = .DisclosureIndicator
                            cell.selectionStyle = .Default
                        }
                    },
                    ""
                ],
                [
                    "ITEMS",
                    { (cell:UITableViewCell) in
                        if let label = cell.textLabel {
                            label.text          = "Odd rows"
                            if false
                            {
                                let view = UISlider()
                                view.setValue(ItemsDataManager.settingsGetFloatForKey(.SettingsTabItemsRowOddTransparency), animated:true)
                                self.addUpdate({
                                    ItemsDataManager.settingsSetFloat(view.value, forKey:.SettingsTabItemsRowOddTransparency)
                                })
                                cell.accessoryView = view
                            }
                            cell.accessoryType  = .DisclosureIndicator
                            cell.selectionStyle = .Default
                        }
                    },
                    { (cell:UITableViewCell) in
                        if let label = cell.textLabel {
                            label.text          = "Even rows"
                            if false
                            {
                                let view = UISlider()
                                view.setValue(ItemsDataManager.settingsGetFloatForKey(.SettingsTabItemsRowEvenTransparency), animated:true)
                                self.addUpdate({
                                    ItemsDataManager.settingsSetFloat(view.value, forKey:.SettingsTabItemsRowEvenTransparency)
                                })
                                cell.accessoryView = view
                            }
                            cell.accessoryType  = .DisclosureIndicator
                            cell.selectionStyle = .Default
                        }
                    },
                    { (cell:UITableViewCell) in
                        if let label = cell.textLabel {
                            label.text          = "Quantity"
                            cell.selectionStyle = .Default
                            cell.accessoryType  = .DisclosureIndicator
                        }
                    },
                    ""
                ],
        ]
        
        reload()
        
        super.viewWillAppear(animated)
    }
    
    
    
    override func viewWillDisappear(animated: Bool)
    {
        for update in updates {
            update()
        }
        
        updates = []
        
        rows = []
        
        super.viewWillDisappear(animated)
    }
    
    
    
    
}
