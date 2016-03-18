//
//  SettingsController.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class SettingsController : GenericSettingsController
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
    
    
    
    var lastLoadedSettingsName:String?
    
    
    
    override func viewWillAppear(animated: Bool)
    {
        registeredSliders.removeAll()
        registeredSwitches.removeAll()
        
        for update in updates {
            update()
        }
        
        updates = []
        
        actions.removeAll()
        
        rows    = [
            [
                "SETTINGS",
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Save"
                        cell.selectionStyle = .Default
                        self.registerCellSelection(indexPath) {
                            let alert = UIAlertController(title:"Save Settings", message:"Specify name for current settings.", preferredStyle:.Alert)
                            
                            alert.addTextFieldWithConfigurationHandler() {
                                field in
                                // called to configure text field before displayed
                                if self.lastLoadedSettingsName != nil {
                                    field.text = self.lastLoadedSettingsName!
                                }
                                else {
                                    field.text = ""
                                }
                            }
                            
                            let actionSave = UIAlertAction(title:"Save", style:.Default, handler: {
                                action in
                                
                                if let fields = alert.textFields, text = fields[0].text {
                                    if 0 < text.length {
                                        DataManager.settingsSave(text)
                                    }
                                }
                            })
                            
                            let actionCancel = UIAlertAction(title:"Cancel", style:.Cancel, handler: {
                                action in
                            })
                            
                            alert.addAction(actionSave)
                            alert.addAction(actionCancel)
                            
                            AppDelegate.rootViewController.presentViewController(alert, animated:true, completion: {
                                print("completed showing add alert")
                            })
                        }
                    }
                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Load"
                        cell.selectionStyle = .Default
                        cell.accessoryType  = .DisclosureIndicator
                        self.registerCellSelection(indexPath) {
                            let list = DataManager.settingsList()
                            
                            print("settings list =\(list)")
                            
                            if 0 < list.count {
                                let controller = GenericListController()
                                
                                controller.items = DataManager.settingsList().sort()
                                controller.handlerForDidSelectRowAtIndexPath = { (controller:GenericListController,indexPath:NSIndexPath) -> Void in
                                    let selected = controller.items[indexPath.row]
                                    DataManager.settingsUse(selected)
                                    self.lastLoadedSettingsName = selected
                                    controller.navigationController!.popViewControllerAnimated(true)
                                }
                                controller.handlerForCommitEditingStyle = { (controller:GenericListController,commitEditingStyle:UITableViewCellEditingStyle,indexPath:NSIndexPath) -> Bool in
                                    if commitEditingStyle == .Delete {
                                        let selected = controller.items[indexPath.row]
                                        DataManager.settingsRemove(selected)
                                        return true
                                    }
                                    return false
                                }
                                
                                AppDelegate.navigatorForSettings.pushViewController(controller, animated:true)
                            }
                        }
                    }
                },
                
                "Save current settings, or load previously saved settings"
            ],
            
            [
                "CATEGORIES",
                
                createCellForFont(DataManager.settingsGetCategoriesFont(),title:"Categories",key:.SettingsTabCategoriesFont),
                
                createCellForColor(DataManager.settingsGetCategoriesTextColor(),title:"Categories",key:.SettingsTabCategoriesTextColor),
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .Default
                        label.text          = "Uppercase"
                        cell.accessoryView  = self.registerSwitch(DataManager.settingsGetBoolForKey(.SettingsTabCategoriesUppercase), update: { (myswitch:UISwitch) in
                            DataManager.settingsSetBool(myswitch.on, forKey:.SettingsTabCategoriesUppercase)
                        })
                    }
                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .Default
                        label.text          = "Emphasize"
                        cell.accessoryView  = self.registerSwitch(DataManager.settingsGetBoolForKey(.SettingsTabCategoriesEmphasize), update: { (myswitch:UISwitch) in
                            DataManager.settingsSetBool(myswitch.on, forKey:.SettingsTabCategoriesEmphasize)
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

                createCellForFont(DataManager.settingsGetItemsFont(),title:"Items",key:.SettingsTabItemsFont),
                
//                { (cell:UITableViewCell, indexPath:NSIndexPath) in
//                    if let label = cell.textLabel {
//                        label.text          = "  Same as Categories"
//                        cell.accessoryType  = .None
//                        cell.selectionStyle = .Default
//                        
//                        cell.accessoryView  = self.registerSwitch(DataManager.settingsGetBoolForKey(.SettingsTabItemsFontSameAsCategories), update: { (myswitch:UISwitch) in
//                            DataManager.settingsSetBool(myswitch.on, forKey:.SettingsTabItemsFontSameAsCategories)
//                        })
//                    }
//                },
                
                createCellForColor(DataManager.settingsGetItemsTextColor(),title:"Items Text",key:.SettingsTabItemsTextColor),
                
//                { (cell:UITableViewCell, indexPath:NSIndexPath) in
//                    if let label = cell.textLabel {
//                        label.text          = "  Same as Categories"
//                        cell.accessoryType  = .None
//                        cell.selectionStyle = .Default
//                        
//                        cell.accessoryView  = self.registerSwitch(DataManager.settingsGetBoolForKey(.SettingsTabItemsTextColorSameAsCategories), update: { (myswitch:UISwitch) in
//                            DataManager.settingsSetBool(myswitch.on, forKey:.SettingsTabItemsTextColorSameAsCategories)
//                        })
//                    }
//                },
                
                ""
            ],

            [
                "ITEM ROW OPACITY",
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Even"
                        cell.accessoryView  = self.registerSlider(DataManager.settingsGetFloatForKey(.SettingsTabItemsRowEvenOpacity, defaultValue:1), update: { (myslider:UISlider) in
                            DataManager.settingsSetFloat(myslider.value, forKey:.SettingsTabItemsRowEvenOpacity)
                        })
                        cell.accessoryType  = .DisclosureIndicator
                        cell.selectionStyle = .Default
                    }
                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Odd"
                        cell.accessoryView  = self.registerSlider(DataManager.settingsGetFloatForKey(.SettingsTabItemsRowOddOpacity, defaultValue:1), update: { (myslider:UISlider) in
                            DataManager.settingsSetFloat(myslider.value, forKey:.SettingsTabItemsRowOddOpacity)
                        })
                        cell.accessoryType  = .DisclosureIndicator
                        cell.selectionStyle = .Default
                    }
                },
                
                "Make the background color of an item row stand out or fade."
            ],
            
            
            [
                "ITEM QUANTITY",
                
                createCellForFont(DataManager.settingsGetItemsQuantityFont(),title:"Quantity",key:.SettingsTabItemsQuantityFont),
                
//                { (cell:UITableViewCell, indexPath:NSIndexPath) in
//                    if let label = cell.textLabel {
//                        label.text          = "  Same as Items"
//                        cell.accessoryType  = .None
//                        cell.selectionStyle = .Default
//
//                        cell.accessoryView  = self.registerSwitch(DataManager.settingsGetBoolForKey(.SettingsTabItemsQuantityFontSameAsItems), update: { (myswitch:UISwitch) in
//                            DataManager.settingsSetBool(myswitch.on, forKey:.SettingsTabItemsQuantityFontSameAsItems)
//                        })
//                    }
//                },
                
                createCellForColor(DataManager.settingsGetItemsQuantityTextColor(),title:"Quantity Text",key:.SettingsTabItemsQuantityColorText),
                
                createCellForColor(DataManager.settingsGetItemsQuantityBackgroundColorWithOpacity(false),name:"Background", title:"Quantity Background",key:.SettingsTabItemsQuantityColorBackground),
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "  Opacity"
                        cell.accessoryView  = self.registerSlider(DataManager.settingsGetFloatForKey(.SettingsTabItemsQuantityColorBackgroundOpacity, defaultValue:1), update: { (myslider:UISlider) in
                            DataManager.settingsSetFloat(myslider.value, forKey:.SettingsTabItemsQuantityColorBackgroundOpacity)
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
        
        actions.removeAll()
        
        DataManager.synchronize()
        
        super.viewWillDisappear(animated)
    }
    
    
    
    
    
}
