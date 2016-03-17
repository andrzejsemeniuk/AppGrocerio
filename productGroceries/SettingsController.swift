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
    
    
    typealias Action = () -> ()
    
    private var actions:[NSIndexPath : Action] = [:]
    
    func addAction(indexPath:NSIndexPath, action:Action) {
        actions[indexPath] = action
    }

    
    typealias Update = Action
    
    private var updates:[Update] = []
    
    func addUpdate(update:Update) {
        updates.append(update)
    }
    
    

    typealias FunctionUpdateOnSwitch = (UISwitch) -> ()
    
    var registeredSwitches:[UISwitch:FunctionUpdateOnSwitch] = [:]
    
    private func registerSwitch(on:Bool, animated:Bool = true, update:FunctionUpdateOnSwitch) -> UISwitch {
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
    
    private func registerSlider(value:Float, minimum:Float = 0, maximum:Float = 1, animated:Bool = true, update:FunctionUpdateOnSlider) -> UISlider {
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
        let cell = UITableViewCell(style:.Value1,reuseIdentifier:nil)
        
        cell.selectionStyle = .None
        
        if let f = rows[indexPath.section][indexPath.row+1] as? FunctionOnCell {
            f(cell:cell,indexPath:indexPath)
        }
        
        return cell
    }
    
    
    
    
    
    
    
    
    func reload()
    {
        tableView.reloadData()
    }
    
    
    
    
    
    
    func createCellForFont(font0:UIFont, name:String = "Font", title:String, key:ItemsDataManager.Key) -> FunctionOnCell
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
                            ItemsDataManager.settingsSetString(fonts.selected, forKey:key)
                        }
                        
                        AppDelegate.navigatorForSettings.pushViewController(fonts, animated:true)
                    }
                }
        }
    }
    
    
    func createCellForColor(color0:UIColor, name:String = "Color", title:String, key:ItemsDataManager.Key) -> FunctionOnCell
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
                            ItemsDataManager.settingsSetColor(colors.selected, forKey:key)
                        }
                        
                        AppDelegate.navigatorForSettings.pushViewController(colors, animated:true)
                    }
                }
        }
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        registeredSliders.removeAll()
        registeredSwitches.removeAll()
        
        for update in updates {
            update()
        }
        
        updates = []
        
        actions = [:]
        
        rows    = [
            [
                "SETTINGS",
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Save"
                        cell.selectionStyle = .Default
                    }
                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
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
                
                createCellForFont(ItemsDataManager.settingsGetCategoriesFont(),title:"Categories",key:.SettingsTabCategoriesFont),
                
                createCellForColor(ItemsDataManager.settingsGetCategoriesTextColor(),title:"Categories",key:.SettingsTabCategoriesTextColor),
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .Default
                        label.text          = "Uppercase"
                        cell.accessoryView  = self.registerSwitch(ItemsDataManager.settingsGetBoolForKey(.SettingsTabCategoriesUppercase), update: { (myswitch:UISwitch) in
                            ItemsDataManager.settingsSetBool(myswitch.on, forKey:.SettingsTabCategoriesUppercase)
                        })
                    }
                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Theme"
                        cell.accessoryType  = .DisclosureIndicator
                        cell.selectionStyle = .Default
                    }
                },
                
                ""
            ],
            
            [
                "ITEM TEXT",

                createCellForFont(ItemsDataManager.settingsGetItemsFont(),title:"Items",key:.SettingsTabItemsFont),
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "  Same as Categories"
                        cell.accessoryType  = .None
                        cell.selectionStyle = .Default
                        
                        cell.accessoryView  = self.registerSwitch(ItemsDataManager.settingsGetBoolForKey(.SettingsTabItemsFontSameAsCategories), update: { (myswitch:UISwitch) in
                            ItemsDataManager.settingsSetBool(myswitch.on, forKey:.SettingsTabItemsFontSameAsCategories)
                        })
                    }
                },
                
                createCellForColor(ItemsDataManager.settingsGetItemsTextColor(),title:"Items Text",key:.SettingsTabItemsTextColor),
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "  Same as Categories"
                        cell.accessoryType  = .None
                        cell.selectionStyle = .Default
                        
                        cell.accessoryView  = self.registerSwitch(ItemsDataManager.settingsGetBoolForKey(.SettingsTabItemsTextColorSameAsCategories), update: { (myswitch:UISwitch) in
                            ItemsDataManager.settingsSetBool(myswitch.on, forKey:.SettingsTabItemsTextColorSameAsCategories)
                        })
                    }
                },
                
                ""
            ],

            [
                "ITEM ROW OPACITY",
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Even"
                        cell.accessoryView  = self.registerSlider(ItemsDataManager.settingsGetFloatForKey(.SettingsTabItemsRowEvenOpacity), update: { (myslider:UISlider) in
                            ItemsDataManager.settingsSetFloat(myslider.value, forKey:.SettingsTabItemsRowEvenOpacity)
                        })
                        cell.accessoryType  = .DisclosureIndicator
                        cell.selectionStyle = .Default
                    }
                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Odd"
                        cell.accessoryView  = self.registerSlider(ItemsDataManager.settingsGetFloatForKey(.SettingsTabItemsRowOddOpacity), update: { (myslider:UISlider) in
                            ItemsDataManager.settingsSetFloat(myslider.value, forKey:.SettingsTabItemsRowOddOpacity)
                        })
                        cell.accessoryType  = .DisclosureIndicator
                        cell.selectionStyle = .Default
                    }
                },
                
                "Make the background color of an item row stand out or fade."
            ],
            
            
            [
                "ITEM QUANTITY",
                
                createCellForFont(ItemsDataManager.settingsGetItemsQuantityFont(),title:"Quantity",key:.SettingsTabItemsQuantityFont),
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "  Same as Items"
                        cell.accessoryType  = .None
                        cell.selectionStyle = .Default

                        cell.accessoryView  = self.registerSwitch(ItemsDataManager.settingsGetBoolForKey(.SettingsTabItemsQuantityFontSameAsItems), update: { (myswitch:UISwitch) in
                            ItemsDataManager.settingsSetBool(myswitch.on, forKey:.SettingsTabItemsQuantityFontSameAsItems)
                        })
                    }
                },
                
                createCellForColor(ItemsDataManager.settingsGetItemsQuantityTextColor(),title:"Quantity Text",key:.SettingsTabItemsQuantityColorText),
                
                createCellForColor(ItemsDataManager.settingsGetItemsQuantityBackgroundColorWithOpacity(false),name:"Background", title:"Quantity Background",key:.SettingsTabItemsQuantityColorBackground),
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "  Opacity"
                        cell.accessoryView  = self.registerSlider(ItemsDataManager.settingsGetFloatForKey(.SettingsTabItemsQuantityColorBackgroundOpacity), update: { (myslider:UISlider) in
                            ItemsDataManager.settingsSetFloat(myslider.value, forKey:.SettingsTabItemsQuantityColorBackgroundOpacity)
                        })
                        cell.accessoryType  = .DisclosureIndicator
                        cell.selectionStyle = .Default
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
        registeredSliders.removeAll()
        registeredSwitches.removeAll()
        
        for update in updates {
            update()
        }
        
        updates = []
        
        rows    = []
        
        actions = [:]
        
        super.viewWillDisappear(animated)
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let action = actions[indexPath]
        {
            action()
        }
    }
    
    
}
