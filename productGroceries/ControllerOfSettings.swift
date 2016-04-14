//
//  SettingsController.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class SettingsController : GenericControllerOfSettings
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
    
    
    
    
    func rebuild()
    {
        let alert = UIAlertController(title:"Rebuild Categories", message:"This action will re-add any missing categories and items.", preferredStyle:.Alert)
        
        let actionOK = UIAlertAction(title:"OK", style:.Default, handler: {
            action in
            
            Data.Manager.createCategories()
            self.reload()
        })
        
        let actionCancel = UIAlertAction(title:"Cancel", style:.Cancel, handler: {
            action in
        })
        
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        
        AppDelegate.rootViewController.presentViewController(alert, animated:true, completion: {
            print("completed showing add alert")
        })
    }
    

    
    
    
    
    override func createRows() -> [[Any]]
    {
        return [
            [
                "SETTINGS",
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.detailTextLabel {
                        label.text = Data.Manager.settingsGetLastName()
                    }
                    if let label = cell.textLabel {
                        label.text          = "Save"
                        cell.selectionStyle = .Default
                        self.registerCellSelection(indexPath) {
                            let alert = UIAlertController(title:"Save Settings", message:"Specify name for current settings.", preferredStyle:.Alert)
                            
                            alert.addTextFieldWithConfigurationHandler() {
                                field in
                                // called to configure text field before displayed
                                field.text = Data.Manager.settingsGetLastName()
                            }
                            
                            let actionSave = UIAlertAction(title:"Save", style:.Default, handler: {
                                action in
                                
                                if let fields = alert.textFields, text = fields[0].text {
                                    if 0 < text.length {
                                        Data.Manager.settingsSave(text)
                                        
                                        print(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
                                        
                                        self.tableView.reloadRowsAtIndexPaths([
                                            indexPath,
                                            NSIndexPath(forRow:indexPath.row+1,inSection:indexPath.section)
                                            ],
                                            withRowAnimation: .Left)
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
                        if Data.Manager.settingsListIsEmpty() {
                            cell.selectionStyle = .None
                            cell.accessoryType  = .None
                        }
                        else {
                            cell.selectionStyle = .Default
                            cell.accessoryType  = .DisclosureIndicator
                        }
                        self.registerCellSelection(indexPath) {
                            let list = Data.Manager.settingsList()
                            
                            print("settings list =\(list)")
                            
                            if 0 < list.count {
                                let controller = GenericControllerOfList()
                                
                                controller.items = Data.Manager.settingsList().sort()
                                controller.handlerForDidSelectRowAtIndexPath = { (controller:GenericControllerOfList,indexPath:NSIndexPath) -> Void in
                                    let selected = controller.items[indexPath.row]
                                    Data.Manager.settingsUse(selected)
                                    AppDelegate.rootViewController.view.backgroundColor = Data.Manager.settingsGetBackgroundColor()
                                    //                                    AppDelegate.controllerOfPages.view.backgroundColor  = Data.Manager.settingsGetBackgroundColor()
                                    controller.navigationController!.popViewControllerAnimated(true)
                                }
                                controller.handlerForCommitEditingStyle = { (controller:GenericControllerOfList,commitEditingStyle:UITableViewCellEditingStyle,indexPath:NSIndexPath) -> Bool in
                                    if commitEditingStyle == .Delete {
                                        let selected = controller.items[indexPath.row]
                                        Data.Manager.settingsRemove(selected)
                                        return true
                                    }
                                    return false
                                }
                                
                                self.navigationController?.pushViewController(controller, animated:true)
                            }
                        }
                    }
                },
                
                "Save current settings, or load previously saved settings"
            ],
            
            [
                "CATEGORIES",
                
                createCellForFont(Data.Manager.settingsGetCategoriesFont(),title:"Categories",key:.SettingsTabCategoriesFont),
                
                createCellForColor(Data.Manager.settingsGetCategoriesTextColor(),title:"Categories",key:.SettingsTabCategoriesTextColor),
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .Default
                        label.text          = "Uppercase"
                        cell.accessoryView  = self.registerSwitch(Data.Manager.settingsGetBoolForKey(.SettingsTabCategoriesUppercase), update: { (myswitch:UISwitch) in
                            Data.Manager.settingsSetBool(myswitch.on, forKey:.SettingsTabCategoriesUppercase)
                        })
                    }
                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .Default
                        label.text          = "Emphasize"
                        cell.accessoryView  = self.registerSwitch(Data.Manager.settingsGetBoolForKey(.SettingsTabCategoriesEmphasize), update: { (myswitch:UISwitch) in
                            Data.Manager.settingsSetBool(myswitch.on, forKey:.SettingsTabCategoriesEmphasize)
                        })
                    }
                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.detailTextLabel {
                        label.text = Data.Manager.settingsGetThemeName()
                    }
                    if let label = cell.textLabel {
                        label.text          = "Background"
                        cell.accessoryType  = .DisclosureIndicator
                        cell.selectionStyle = .Default
                        self.registerCellSelection(indexPath) {
                            let controller = ControllerOfThemes()
                            AppDelegate.navigatorForSettings.pushViewController(controller, animated:true)
                        }
                    }
                },
                
                ""
            ],
            
            [
             
                "",

                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Rebuild"
                        cell.accessoryType  = .None
                        cell.selectionStyle = .Default
                        self.registerCellSelection(indexPath) {
                            self.rebuild()
                        }
                    }
                },
                
                "If you deleted any categories manually, you can re-add them all with Rebuild"
            ],
            
            [
                "ITEM TEXT",

                createCellForFont(Data.Manager.settingsGetItemsFont(),title:"Items",key:.SettingsTabItemsFont),
                
//                { (cell:UITableViewCell, indexPath:NSIndexPath) in
//                    if let label = cell.textLabel {
//                        label.text          = "  Same as Categories"
//                        cell.accessoryType  = .None
//                        cell.selectionStyle = .Default
//                        
//                        cell.accessoryView  = self.registerSwitch(Data.Manager.settingsGetBoolForKey(.SettingsTabItemsFontSameAsCategories), update: { (myswitch:UISwitch) in
//                            Data.Manager.settingsSetBool(myswitch.on, forKey:.SettingsTabItemsFontSameAsCategories)
//                        })
//                    }
//                },
                
                createCellForColor(Data.Manager.settingsGetItemsTextColor(),title:"Items Text",key:.SettingsTabItemsTextColor),
                
//                { (cell:UITableViewCell, indexPath:NSIndexPath) in
//                    if let label = cell.textLabel {
//                        label.text          = "  Same as Categories"
//                        cell.accessoryType  = .None
//                        cell.selectionStyle = .Default
//                        
//                        cell.accessoryView  = self.registerSwitch(Data.Manager.settingsGetBoolForKey(.SettingsTabItemsTextColorSameAsCategories), update: { (myswitch:UISwitch) in
//                            Data.Manager.settingsSetBool(myswitch.on, forKey:.SettingsTabItemsTextColorSameAsCategories)
//                        })
//                    }
//                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .Default
                        label.text          = "Uppercase"
                        cell.accessoryView  = self.registerSwitch(Data.Manager.settingsGetBoolForKey(.SettingsTabItemsUppercase), update: { (myswitch:UISwitch) in
                            Data.Manager.settingsSetBool(myswitch.on, forKey:.SettingsTabItemsUppercase)
                        })
                    }
                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .Default
                        label.text          = "Emphasize"
                        cell.accessoryView  = self.registerSwitch(Data.Manager.settingsGetBoolForKey(.SettingsTabItemsEmphasize), update: { (myswitch:UISwitch) in
                            Data.Manager.settingsSetBool(myswitch.on, forKey:.SettingsTabItemsEmphasize)
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
                        cell.accessoryView  = self.registerSlider(Data.Manager.settingsGetFloatForKey(.SettingsTabItemsRowEvenOpacity, defaultValue:1), update: { (myslider:UISlider) in
                            Data.Manager.settingsSetFloat(myslider.value, forKey:.SettingsTabItemsRowEvenOpacity)
                        })
                        cell.accessoryType  = .None
                        cell.selectionStyle = .Default
                    }
                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Odd"
                        cell.accessoryView  = self.registerSlider(Data.Manager.settingsGetFloatForKey(.SettingsTabItemsRowOddOpacity, defaultValue:1), update: { (myslider:UISlider) in
                            Data.Manager.settingsSetFloat(myslider.value, forKey:.SettingsTabItemsRowOddOpacity)
                        })
                        cell.accessoryType  = .None
                        cell.selectionStyle = .Default
                    }
                },
                
                "Make the background color of an item row stand out or fade."
            ],
            
            
            [
                "ITEM QUANTITY",
                
                createCellForFont(Data.Manager.settingsGetItemsQuantityFont(),title:"Quantity",key:.SettingsTabItemsQuantityFont),
                
//                { (cell:UITableViewCell, indexPath:NSIndexPath) in
//                    if let label = cell.textLabel {
//                        label.text          = "  Same as Items"
//                        cell.accessoryType  = .None
//                        cell.selectionStyle = .Default
//
//                        cell.accessoryView  = self.registerSwitch(Data.Manager.settingsGetBoolForKey(.SettingsTabItemsQuantityFontSameAsItems), update: { (myswitch:UISwitch) in
//                            Data.Manager.settingsSetBool(myswitch.on, forKey:.SettingsTabItemsQuantityFontSameAsItems)
//                        })
//                    }
//                },
                
                createCellForColor(Data.Manager.settingsGetItemsQuantityTextColor(),title:"Quantity Text",key:.SettingsTabItemsQuantityColorText),
                
                createCellForColor(Data.Manager.settingsGetItemsQuantityBackgroundColorWithOpacity(false),name:"Background", title:"Quantity Background",key:.SettingsTabItemsQuantityColorBackground),
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "  Opacity"
                        cell.accessoryView  = self.registerSlider(Data.Manager.settingsGetFloatForKey(.SettingsTabItemsQuantityColorBackgroundOpacity, defaultValue:1), update: { (myslider:UISlider) in
                            Data.Manager.settingsSetFloat(myslider.value, forKey:.SettingsTabItemsQuantityColorBackgroundOpacity)
                        })
                        cell.accessoryType  = .DisclosureIndicator
                        cell.selectionStyle = .Default
                    }
                },
                
                ""
            ],
            
            [
                "SELECTION",
                
                createCellForColor(Data.Manager.settingsGetColorForKey(.SettingsSelectionColor),title:"Selection",key:.SettingsSelectionColor) {
                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Opacity"
                        cell.accessoryView  = self.registerSlider(Data.Manager.settingsGetFloatForKey(.SettingsSelectionColorOpacity, defaultValue:0.2), update: { (myslider:UISlider) in
                            Data.Manager.settingsSetFloat(myslider.value, forKey:.SettingsSelectionColorOpacity)
                        })
                        cell.accessoryType  = .None
                        cell.selectionStyle = .Default
                    }
                },
                
                "Set selection properties for rows on all tabs"
            ],
            
            [
                "APP",
                
                createCellForColor(Data.Manager.settingsGetBackgroundColor(),name:"Background",title:"Background",key:.SettingsBackgroundColor) {
                    AppDelegate.rootViewController.view.backgroundColor     = Data.Manager.settingsGetBackgroundColor()
                    self.view.backgroundColor                               = AppDelegate.rootViewController.view.backgroundColor
                },
                
                { (cell:UITableViewCell, indexPath:NSIndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .Default
                        label.text          = "Audio"
                        cell.accessoryView  = self.registerSwitch(Data.Manager.settingsGetBoolForKey(.SettingsAudioOn,defaultValue:true), update: { (myswitch:UISwitch) in
                            Data.Manager.settingsSetBool(myswitch.on, forKey:.SettingsAudioOn)
                        })
                    }
                },
                

                "Set app properties"
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
    
    
    
    
    override func tableView                     (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = super.tableView(tableView, cellForRowAtIndexPath:indexPath)
        
        cell.selectedBackgroundView = UIView.createWithBackgroundColor(Data.Manager.settingsGetSelectionColor())
        
        return cell
    }
    
    
    
    override func viewWillDisappear(animated: Bool)
    {
        Data.Manager.synchronize()
        
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        tableView.backgroundColor = Data.Manager.settingsGetBackgroundColor()
        
        super.viewWillAppear(animated)
    }

    
    
}
