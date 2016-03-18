//
//  SettingsController.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit


class GenericSettingsController : UITableViewController
{
    var rows:[[Any]] = []
    
    
    
    
    
    override func numberOfSectionsInTableView   (tableView: UITableView) -> Int
    {
        return rows.count
    }
    
    override func tableView                     (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return section < rows.count ? rows[section].count-2 : 0
    }
    
    override func tableView                     (tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if 0 < rows.count {
            if let text = rows[section].first as? String {
                return 0 < text.length ? text : nil
            }
        }
        return nil
    }
    
    override func tableView                     (tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        if 0 < rows.count {
            if let text = rows[section].last as? String {
                return 0 < text.length ? text : nil
            }
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
        let cell = UITableViewCell(style:.Value1,reuseIdentifier:nil)
        
        cell.selectionStyle = .None
        
        if 0 < rows.count {
            if let f = rows[indexPath.section][indexPath.row+1] as? FunctionOnCell {
                f(cell:cell,indexPath:indexPath)
            }
        }
        
        return cell
    }
    
    
    
    
    
    
    
    
    typealias Action = () -> ()
    
    var actions:[NSIndexPath : Action] = [:]
    
    func addAction(indexPath:NSIndexPath, action:Action) {
        actions[indexPath] = action
    }
    
    func registerCellSelection(indexPath:NSIndexPath, action:Action) {
        addAction(indexPath,action:action)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let action = actions[indexPath]
        {
            action()
        }
    }
    
    
    
    
    typealias Update = Action
    
    var updates:[Update] = []
    
    func addUpdate(update:Update) {
        updates.append(update)
    }
    
    
    
    typealias FunctionUpdateOnSwitch = (UISwitch) -> ()
    
    var registeredSwitches:[UISwitch:FunctionUpdateOnSwitch] = [:]
    
    func registerSwitch(on:Bool, animated:Bool = true, update:FunctionUpdateOnSwitch) -> UISwitch {
        let view = UISwitch()
        view.setOn(on, animated:animated)
        registeredSwitches[view] = update
        view.addTarget(self,action:"handleSwitch:",forControlEvents:.ValueChanged)
        return view
    }
    
    func handleSwitch(control:UISwitch?) {
        if let myswitch = control, let update = registeredSwitches[myswitch] {
            update(myswitch)
        }
    }
    
    
    
    
    
    
    typealias FunctionUpdateOnSlider = (UISlider) -> ()
    
    var registeredSliders:[UISlider:FunctionUpdateOnSlider] = [:]
    
    func registerSlider(value:Float, minimum:Float = 0, maximum:Float = 1, animated:Bool = true, update:FunctionUpdateOnSlider) -> UISlider {
        let view = UISlider()
        view.minimumValue = minimum
        view.maximumValue = maximum
        view.value = value
        registeredSliders[view] = update
        view.addTarget(self,action:"handleSlider:",forControlEvents:.ValueChanged)
        return view
    }
    
    func handleSlider(control:UISlider?) {
        if let myslider = control, let update = registeredSliders[myslider] {
            update(myslider)
        }
    }
    
    
    
    
    typealias FunctionOnCell = (cell:UITableViewCell, indexPath:NSIndexPath) -> ()
    
    func createCellForFont(font0:UIFont, name:String = "Font", title:String, key:DataManager.Key, action:Action! = nil) -> FunctionOnCell
    {
        return
            { (cell:UITableViewCell, indexPath:NSIndexPath) in
                if let label = cell.textLabel {
                    
                    label.text          = name
                    if let detail = cell.detailTextLabel {
                        detail.text = font0.familyName
                    }
                    cell.selectionStyle = .Default
                    cell.accessoryType  = .DisclosureIndicator
                    self.addAction(indexPath) {
                        
                        if action != nil {
                            action()
                        }
                        
                        let fonts       = FontNamePicker()
                        
                        fonts.title     = title+" Font"
                        
                        fonts.names     = UIFont.familyNames()
                        
                        fonts.selected  = font0.familyName
                        
                        fonts.update    = {
                            DataManager.settingsSetString(fonts.selected, forKey:key)
                        }
                        
                        AppDelegate.navigatorForSettings.pushViewController(fonts, animated:true)
                    }
                }
        }
    }
    
    
    func createCellForColor(color0:UIColor, postProcess:((UITableViewCell) -> Void)! = nil, name:String = "Color", title:String, key:DataManager.Key, action:Action! = nil) -> FunctionOnCell
    {
        return
            { (cell:UITableViewCell, indexPath:NSIndexPath) in
                if let label = cell.textLabel {
                    
                    label.text          = name
                    if let detail = cell.detailTextLabel {
                        detail.text = "  "
                        let view = UIView()
                        
                        view.frame              = CGRectMake(-16,-2,24,24)
                        view.backgroundColor    = color0
                        
                        detail.addSubview(view)
                    }
                    cell.selectionStyle = .Default
                    cell.accessoryType  = .DisclosureIndicator
                    
                    if postProcess != nil {
                        postProcess(cell)
                    }
                    
                    self.addAction(indexPath) {
                        
                        if action != nil {
                            action()
                        }
                        
                        let colors      = ColorPicker()
                        
                        colors.title    = title+" Color"
                        
                        colors.selected = color0
                        
                        colors.update   = {
                            DataManager.settingsSetColor(colors.selected, forKey:key)
                        }
                        
                        AppDelegate.navigatorForSettings.pushViewController(colors, animated:true)
                    }
                }
        }
    }
    
    
    
    func reload()
    {
        tableView.reloadData()
    }
    
    
    func createRows() -> [[Any]]
    {
        return [[Any]]()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        registeredSliders.removeAll()
        registeredSwitches.removeAll()
        
        updates.removeAll()
        
        actions.removeAll()
        
        rows = createRows()
        
        reload()
        
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewWillDisappear(animated: Bool)
    {
        registeredSliders.removeAll()
        registeredSwitches.removeAll()
        
        for update in updates {
            update()
        }
        
        updates.removeAll()
        
        rows.removeAll()
        
        actions.removeAll()
        
        super.viewWillDisappear(animated)
    }
    
    
    
    
    
    
    
}