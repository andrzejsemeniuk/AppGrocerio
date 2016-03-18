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
    
    
    
    
    
    
    
    
    
    override func createRows() -> [[Any]]
    {
        return [
            [
                "SETTINGS",
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.detailTextLabel {
                        label.text = DataManager.settingsGetLastName()
                    }
                    if let label = cell.textLabel {
                        label.text          = "Save"
                        cell.selectionStyle = .Default
                        self.registerCellSelection(indexPath) {
                            let alert = UIAlertController(title:"Save Settings", message:"Specify name for current settings.", preferredStyle:.Alert)
                            
                            alert.addTextFieldWithConfigurationHandler() {
                                field in
                                // called to configure text field before displayed
                                field.text = DataManager.settingsGetLastName()
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
                "BACKGROUND",
                
                createCellForColor(DataManager.settingsGetBackgroundColor(),title:"Background",key:.SettingsBackgroundColor) {
                    AppDelegate.rootViewController.view.backgroundColor = DataManager.settingsGetBackgroundColor()
                },
                
                ""
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
                    if let label = cell.detailTextLabel {
                        label.text = DataManager.settingsGetThemeName()
                    }
                    if let label = cell.textLabel {
                        label.text          = "Theme"
                        cell.accessoryType  = .DisclosureIndicator
                        cell.selectionStyle = .Default
                        self.registerCellSelection(indexPath) {
                            let controller = ThemesController()
                            AppDelegate.navigatorForSettings.pushViewController(controller, animated:true)
                        }
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
            
//            [
//                "ITEM QUANTITY SOUNDS",
//                
//                { (cell:UITableViewCell, indexPath:NSIndexPath) in
//                    if let label = cell.textLabel {
//                        label.text          = "Add"
//                        cell.selectionStyle = .Default
//                        cell.accessoryType  = .DisclosureIndicator
//                        self.registerCellSelection(indexPath) {
//                            // None,Default,Zap,Pop,Crackle
//                        }
//                    }
//                },
//                
//                { (cell:UITableViewCell, indexPath:NSIndexPath) in
//                    if let label = cell.textLabel {
//                        label.text          = "Subtract"
//                        cell.selectionStyle = .Default
//                        cell.accessoryType  = .DisclosureIndicator
//                        self.registerCellSelection(indexPath) {
//                        }
//                    }
//                },
//                
//                { (cell:UITableViewCell, indexPath:NSIndexPath) in
//                    if let label = cell.textLabel {
//                        label.text          = "Error"
//                        cell.selectionStyle = .Default
//                        cell.accessoryType  = .DisclosureIndicator
//                        self.registerCellSelection(indexPath) {
//                        }
//                    }
//                },
//                
//
//                ""
//            ],

        ]
    }
    
    
    
    
    override func viewWillDisappear(animated: Bool)
    {
        DataManager.synchronize()
        
        super.viewWillDisappear(animated)
    }
    
    
    
    
    
}
