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
    
    func createCellForFont(font0:UIFont, name:String = "Font", title:String, key:DataManager.Key) -> FunctionOnCell
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
    
    
    func createCellForColor(color0:UIColor, name:String = "Color", title:String, key:DataManager.Key) -> FunctionOnCell
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
                    self.addAction(indexPath) {
                        
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
    
}