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
        tableView               = UITableView(frame:tableView.frame,style:.grouped)
        
        tableView.dataSource    = self
        
        tableView.delegate      = self
        
        
        tableView.separatorStyle = .none
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    func rebuild()
    {
        let alert = UIAlertController(title:"Rebuild Categories", message:"This action will re-add any missing categories and items.", preferredStyle:.alert)
        
        let actionOK = UIAlertAction(title:"OK", style:.default, handler: {
            action in
            
            Data.Manager.createCategories()
            self.reload()
        })
        
        let actionCancel = UIAlertAction(title:"Cancel", style:.cancel, handler: {
            action in
        })
        
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        
        AppDelegate.rootViewController.present(alert, animated:true, completion: {
            print("completed showing add alert")
        })
    }
    

    
    
    
    
    override func createRows() -> [[Any]]
    {
        return [
            [
                "SETTINGS",
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.detailTextLabel {
                        label.text = Data.Manager.settingsGetLastName()
                    }
                    if let label = cell.textLabel {
                        label.text          = "Save"
                        cell.selectionStyle = .default
                        self.registerCellSelection(indexPath: indexPath) {
                            let alert = UIAlertController(title:"Save Settings", message:"Specify name for current settings.", preferredStyle:.alert)
                            
                            alert.addTextField() {
                                field in
                                // called to configure text field before displayed
                                field.text = Data.Manager.settingsGetLastName()
                            }
                            
                            let actionSave = UIAlertAction(title:"Save", style:.default, handler: {
                                action in
                                
                                if let fields = alert.textFields, let text = fields[0].text {
                                    if 0 < text.length {
                                        _ = Data.Manager.settingsSave(text)
                                        
                                        print(UserDefaults.standard.dictionaryRepresentation())
                                        
                                        self.tableView.reloadRows(at: [
                                            indexPath,
                                            IndexPath(row:indexPath.row+1,section:indexPath.section) as IndexPath
                                            ],
                                                                  with: .left)
                                    }
                                }
                            })
                            
                            let actionCancel = UIAlertAction(title:"Cancel", style:.cancel, handler: {
                                action in
                            })
                            
                            alert.addAction(actionSave)
                            alert.addAction(actionCancel)
                            
                            AppDelegate.rootViewController.present(alert, animated:true, completion: {
                                print("completed showing add alert")
                            })
                        }
                    }
                },
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Load"
                        if Data.Manager.settingsListIsEmpty() {
                            cell.selectionStyle = .none
                            cell.accessoryType  = .none
                        }
                        else {
                            cell.selectionStyle = .default
                            cell.accessoryType  = .disclosureIndicator
                        }
                        self.registerCellSelection(indexPath: indexPath) {
                            let list = Data.Manager.settingsList()
                            
                            print("settings list =\(list)")
                            
                            if 0 < list.count {
                                let controller = GenericControllerOfList()
                                
                                controller.items = Data.Manager.settingsList().sorted()
                                controller.handlerForDidSelectRowAtIndexPath = { controller, indexPath in
                                    let selected = controller.items[indexPath.row]
                                    _ = Data.Manager.settingsUse(selected)
                                    AppDelegate.rootViewController.view.backgroundColor = Data.Manager.settingsGetBackgroundColor()
                                    //                                    AppDelegate.controllerOfPages.view.backgroundColor  = Data.Manager.settingsGetBackgroundColor()
                                    controller.navigationController!.popViewController(animated: true)
                                }
                                controller.handlerForCommitEditingStyle = { controller, commitEditingStyle, indexPath in
                                    if commitEditingStyle == .delete {
                                        let selected = controller.items[indexPath.row]
                                        _ = Data.Manager.settingsRemove(selected)
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
                
                createCellForFont(font0: Data.Manager.settingsGetCategoriesFont(),title:"Categories",key:.SettingsTabCategoriesFont),
                
                createCellForColor(color0: Data.Manager.settingsGetCategoriesTextColor(),title:"Categories",key:.SettingsTabCategoriesTextColor),
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .default
                        label.text          = "Uppercase"
                        cell.accessoryView  = self.registerSwitch(on: Data.Manager.settingsGetBoolForKey(.SettingsTabCategoriesUppercase), update: { (myswitch:UISwitch) in
                            Data.Manager.settingsSetBool(myswitch.isOn, forKey:.SettingsTabCategoriesUppercase)
                        })
                    }
                },
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .default
                        label.text          = "Emphasize"
                        cell.accessoryView  = self.registerSwitch(on: Data.Manager.settingsGetBoolForKey(.SettingsTabCategoriesEmphasize), update: { (myswitch:UISwitch) in
                            Data.Manager.settingsSetBool(myswitch.isOn, forKey:.SettingsTabCategoriesEmphasize)
                        })
                    }
                },
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.detailTextLabel {
                        label.text = Data.Manager.settingsGetThemeName()
                    }
                    if let label = cell.textLabel {
                        label.text          = "Background"
                        cell.accessoryType  = .disclosureIndicator
                        cell.selectionStyle = .default
                        self.registerCellSelection(indexPath: indexPath) {
                            let controller = ControllerOfThemes()
                            AppDelegate.navigatorForSettings.pushViewController(controller, animated:true)
                        }
                    }
                },
                
                ""
            ],
            
            [
             
                "",

                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Rebuild"
                        cell.accessoryType  = .none
                        cell.selectionStyle = .default
                        self.registerCellSelection(indexPath: indexPath) {
                            self.rebuild()
                        }
                    }
                },
                
                "If you deleted any categories manually, you can re-add them all with Rebuild"
            ],
            
            [
                "ITEM TEXT",

                createCellForFont(font0: Data.Manager.settingsGetItemsFont(),title:"Items",key:.SettingsTabItemsFont),
                
//                { (cell:UITableViewCell, indexPath:IndexPath) in
//                    if let label = cell.textLabel {
//                        label.text          = "  Same as Categories"
//                        cell.accessoryType  = .none
//                        cell.selectionStyle = .default
//                        
//                        cell.accessoryView  = self.registerSwitch(on: Data.Manager.settingsGetBoolForKey(.SettingsTabItemsFontSameAsCategories), update: { (myswitch:UISwitch) in
//                            Data.Manager.settingsSetBool(myswitch.on, forKey:.SettingsTabItemsFontSameAsCategories)
//                        })
//                    }
//                },
                
                createCellForColor(color0: Data.Manager.settingsGetItemsTextColor(),title:"Items Text",key:.SettingsTabItemsTextColor),
                
//                { (cell:UITableViewCell, indexPath:IndexPath) in
//                    if let label = cell.textLabel {
//                        label.text          = "  Same as Categories"
//                        cell.accessoryType  = .none
//                        cell.selectionStyle = .default
//                        
//                        cell.accessoryView  = self.registerSwitch(on: Data.Manager.settingsGetBoolForKey(.SettingsTabItemsTextColorSameAsCategories), update: { (myswitch:UISwitch) in
//                            Data.Manager.settingsSetBool(myswitch.on, forKey:.SettingsTabItemsTextColorSameAsCategories)
//                        })
//                    }
//                },
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .default
                        label.text          = "Uppercase"
                        cell.accessoryView  = self.registerSwitch(on: Data.Manager.settingsGetBoolForKey(.SettingsTabItemsUppercase), update: { (myswitch:UISwitch) in
                            Data.Manager.settingsSetBool(myswitch.isOn, forKey:.SettingsTabItemsUppercase)
                        })
                    }
                },
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .default
                        label.text          = "Emphasize"
                        cell.accessoryView  = self.registerSwitch(on: Data.Manager.settingsGetBoolForKey(.SettingsTabItemsEmphasize), update: { (myswitch:UISwitch) in
                            Data.Manager.settingsSetBool(myswitch.isOn, forKey:.SettingsTabItemsEmphasize)
                        })
                    }
                },
                

                ""
            ],

            [
                "ITEM ROW OPACITY",
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Even"
                        cell.accessoryView  = self.registerSlider(value: Data.Manager.settingsGetFloatForKey(.SettingsTabItemsRowEvenOpacity, defaultValue:1), update: { (myslider:UISlider) in
                            Data.Manager.settingsSetFloat(myslider.value, forKey:.SettingsTabItemsRowEvenOpacity)
                        })
                        cell.accessoryType  = .none
                        cell.selectionStyle = .default
                    }
                },
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Odd"
                        cell.accessoryView  = self.registerSlider(value: Data.Manager.settingsGetFloatForKey(.SettingsTabItemsRowOddOpacity, defaultValue:1), update: { (myslider:UISlider) in
                            Data.Manager.settingsSetFloat(myslider.value, forKey:.SettingsTabItemsRowOddOpacity)
                        })
                        cell.accessoryType  = .none
                        cell.selectionStyle = .default
                    }
                },
                
                "Make the background color of an item row stand out or fade."
            ],
            
            
            [
                "ITEM QUANTITY",
                
                createCellForFont(font0: Data.Manager.settingsGetItemsQuantityFont(),title:"Quantity",key:.SettingsTabItemsQuantityFont),
                
//                { (cell:UITableViewCell, indexPath:IndexPath) in
//                    if let label = cell.textLabel {
//                        label.text          = "  Same as Items"
//                        cell.accessoryType  = .none
//                        cell.selectionStyle = .default
//
//                        cell.accessoryView  = self.registerSwitch(on: Data.Manager.settingsGetBoolForKey(.SettingsTabItemsQuantityFontSameAsItems), update: { (myswitch:UISwitch) in
//                            Data.Manager.settingsSetBool(myswitch.on, forKey:.SettingsTabItemsQuantityFontSameAsItems)
//                        })
//                    }
//                },
                
                createCellForColor(color0: Data.Manager.settingsGetItemsQuantityTextColor(),title:"Quantity Text",key:.SettingsTabItemsQuantityColorText),
                
                createCellForColor(color0: Data.Manager.settingsGetItemsQuantityBackgroundColorWithOpacity(false),name:"Background", title:"Quantity Background",key:.SettingsTabItemsQuantityColorBackground),
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "  Opacity"
                        cell.accessoryView  = self.registerSlider(value: Data.Manager.settingsGetFloatForKey(.SettingsTabItemsQuantityColorBackgroundOpacity, defaultValue:1), update: { (myslider:UISlider) in
                            Data.Manager.settingsSetFloat(myslider.value, forKey:.SettingsTabItemsQuantityColorBackgroundOpacity)
                        })
                        cell.accessoryType  = .disclosureIndicator
                        cell.selectionStyle = .default
                    }
                },
                
                ""
            ],
            
            [
                "SELECTION",
                
                createCellForColor(color0: Data.Manager.settingsGetColorForKey(.SettingsSelectionColor),title:"Selection",key:.SettingsSelectionColor) {
                },
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.textLabel {
                        label.text          = "Opacity"
                        cell.accessoryView  = self.registerSlider(value: Data.Manager.settingsGetFloatForKey(.SettingsSelectionColorOpacity, defaultValue:0.2), update: { (myslider:UISlider) in
                            Data.Manager.settingsSetFloat(myslider.value, forKey:.SettingsSelectionColorOpacity)
                        })
                        cell.accessoryType  = .none
                        cell.selectionStyle = .default
                    }
                },
                
                "Set selection properties for rows on all tabs"
            ],
            
            [
                "APP",
                
                createCellForColor(color0: Data.Manager.settingsGetBackgroundColor(),name:"Background",title:"Background",key:.SettingsBackgroundColor) {
                    AppDelegate.rootViewController.view.backgroundColor     = Data.Manager.settingsGetBackgroundColor()
                    self.view.backgroundColor                               = AppDelegate.rootViewController.view.backgroundColor
                },
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
                    if let label = cell.textLabel {
                        cell.selectionStyle = .default
                        label.text          = "Audio"
                        cell.accessoryView  = self.registerSwitch(on: Data.Manager.settingsGetBoolForKey(.SettingsAudioOn,defaultValue:true), update: { (myswitch:UISwitch) in
                            Data.Manager.settingsSetBool(myswitch.isOn, forKey:.SettingsAudioOn)
                        })
                    }
                },
                

                "Set app properties"
            ],
            
//            [
//                "ITEM QUANTITY SOUNDS",
//                
//                { (cell:UITableViewCell, indexPath:IndexPath) in
//                    if let label = cell.textLabel {
//                        label.text          = "Add"
//                        cell.selectionStyle = .default
//                        cell.accessoryType  = .disclosureIndicator
//                        self.registerCellSelection(indexPath) {
//                            // None,Default,Zap,Pop,Crackle
//                        }
//                    }
//                },
//                
//                { (cell:UITableViewCell, indexPath:IndexPath) in
//                    if let label = cell.textLabel {
//                        label.text          = "Subtract"
//                        cell.selectionStyle = .default
//                        cell.accessoryType  = .disclosureIndicator
//                        self.registerCellSelection(indexPath) {
//                        }
//                    }
//                },
//                
//                { (cell:UITableViewCell, indexPath:IndexPath) in
//                    if let label = cell.textLabel {
//                        label.text          = "Error"
//                        cell.selectionStyle = .default
//                        cell.accessoryType  = .disclosureIndicator
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
    
    
    
    
    override func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = super.tableView(tableView, cellForRowAt:indexPath)
        
        cell.selectedBackgroundView = UIView.createWithBackgroundColor(Data.Manager.settingsGetSelectionColor())
        
        return cell
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        Data.Manager.synchronize()
        
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        tableView.backgroundColor   = Data.Manager.settingsGetBackgroundColor()
        
        colorForHeaderText          = Data.Manager.settingsGetColorForKey(.SettingsTabSettingsHeaderTextColor,defaultValue:UIColor.gray)
        colorForFooterText          = Data.Manager.settingsGetColorForKey(.SettingsTabSettingsFooterTextColor,defaultValue:UIColor.gray)
        
        super.viewWillAppear(animated)
    }

    
    
}
