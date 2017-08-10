//
//  SettingsController.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit
import ASToolkit

class SettingsController : GenericControllerOfSettings
{
    
    var preferences:Preferences {
        return AppDelegate.instance.preferences
    }
    
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
            
            Store.Manager.createCategories()
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
                
//                { (cell:UITableViewCell, indexPath:IndexPath) in
//                    if let label = cell.detailTextLabel {
//                        label.text = Store.Manager.settingsGetLastName()
//                    }
//                    if let label = cell.textLabel {
//                        label.text          = "Save"
//                        cell.selectionStyle = .default
//                        self.registerCellSelection(indexPath: indexPath) {
//                            let alert = UIAlertController(title:"Save Settings", message:"Specify name for current settings.", preferredStyle:.alert)
//                            
//                            alert.addTextField() {
//                                field in
//                                // called to configure text field before displayed
//                                field.text = Store.Manager.settingsGetLastName()
//                            }
//                            
//                            let actionSave = UIAlertAction(title:"Save", style:.default, handler: {
//                                action in
//                                
//                                if let fields = alert.textFields, let text = fields[0].text {
//                                    if 0 < text.length {
//                                        _ = Store.Manager.settingsSave(text)
//                                        
//                                        print(UserDefaults.standard.dictionaryRepresentation())
//                                        
//                                        self.tableView.reloadRows(at: [
//                                            indexPath,
//                                            IndexPath(row:indexPath.row+1,section:indexPath.section) as IndexPath
//                                            ],
//                                                                  with: .left)
//                                    }
//                                }
//                            })
//                            
//                            let actionCancel = UIAlertAction(title:"Cancel", style:.cancel, handler: {
//                                action in
//                            })
//                            
//                            alert.addAction(actionSave)
//                            alert.addAction(actionCancel)
//                            
//                            AppDelegate.rootViewController.present(alert, animated:true, completion: {
//                                print("completed showing add alert")
//                            })
//                        }
//                    }
//                },
                
                createCellForTap(title: "Load", detail:preferences.settingCurrent.value ,setup: { cell,indexpath in
                    cell.selectionStyle = .default
                    cell.accessoryType  = .disclosureIndicator
                }) { [weak self] in
                    
                    guard let `self` = self else { return }

                    let list = self.preferences.settingList.value.split(",")
                    
                    print("settings list =\(list)")
                    
                    if 0 < list.count {
                        
                        let controller = GenericControllerOfList()
                        
                        controller.items = list.sorted()
                        
                        controller.handlerForDidSelectRowAtIndexPath = { [weak self] controller, indexPath in
                            guard let `self` = self else { return }
                            let selected = controller.items[indexPath.row]
                            self.preferences.theme(loadWithName:selected)
                            AppDelegate.rootViewController.view.backgroundColor = self.preferences.settingBackgroundColor.value
                            controller.navigationController?.popViewController(animated: true)
                        }
                        
                        controller.handlerForCommitEditingStyle = { [weak self] controller, commitEditingStyle, indexPath in
                            guard
                                let `self` = self,
                                commitEditingStyle == .delete
                                else {
                                    return false
                            }
                            // TODO: TEST
                            let selected = controller.items[indexPath.row]
                            var newlist = list
                            if let index = newlist.index(where: { $0 == selected }) {
                                newlist.remove(at:index)
                                self.preferences.settingList.value = newlist.joined(separator:",")
                                return true
                            }
                            return false
                        }
                        
                        self.navigationController?.pushViewController(controller, animated:true)
                    }

                },
                
                "Save current settings, or load previously saved settings"
            ],
            
            [
                "CATEGORIES",
                
                createCellForUIFontName (preferences.settingTabCategoriesFont, title: "Font"),
                
                createCellForUIColor(preferences.settingTabCategoriesTextColor, title: "Color"),
                
                createCellForUISwitch(preferences.settingTabCategoriesUppercase, title: "Uppercase"),
                
                createCellForUISwitch(preferences.settingTabCategoriesEmphasize, title: "Emphasize"),

                createCellForTap(title: "Background", detail:preferences.settingTabThemesName.value) {
                    let controller = ControllerOfThemes()
                    AppDelegate.navigatorForSettings.pushViewController(controller, animated:true)
                },

                ""
            ],
            
            [
             
                "",

                createCellForTap(title: "Rebuild") { [weak self] in
                    self?.rebuild()
                },
                
                "If you deleted any categories manually, you can re-add them all with Rebuild"
            ],
            
            [
                "ITEM TEXT",

                createCellForUIFontName(preferences.settingTabItemsFont, title: "Font"),
                
                createCellForUISwitch(preferences.settingTabItemsFontSameAsCategories, title: "  Same as Categories"),
                
                createCellForUIColor(preferences.settingTabItemsTextColor, title:"Color"),
                
                createCellForUISwitch(preferences.settingTabItemsTextColorSameAsCategories, title: "  Same as Categories"),
                
                createCellForUISwitch(preferences.settingTabItemsUppercase, title: "Uppercase"),
                
                createCellForUISwitch(preferences.settingTabItemsEmphasize, title: "Emphasize"),
                
                ""
            ],

            [
                "ITEM ROW OPACITY",
                
                createCellForUISlider(preferences.settingTabItemsRowEvenOpacity, title: "Even"),

                createCellForUISlider(preferences.settingTabItemsRowOddOpacity, title: "Odd"),

                "Make the background color of an item row stand out or fade."
            ],
            
            
            [
                "ITEM QUANTITY",

                createCellForUIFontName(preferences.settingTabItemsQuantityFont, title: "Font"),
                
                createCellForUIColor(preferences.settingTabItemsQuantityColorText, title: "Color"),
                
                createCellForUIColor(preferences.settingTabItemsQuantityColorBackground , title: "Background"),
                
                createCellForUISlider(preferences.settingTabItemsQuantityColorBackgroundOpacity, title: "Opacity"),

                ""
            ],
            
            [
                "SELECTION",
                
                createCellForUIColor(preferences.settingSelectionColor, title: "Background"),
                
                createCellForUISlider(preferences.settingSelectionColorOpacity, title: "Opacity"),
                
                "Set selection properties for rows on all tabs"
            ],
            
            [
                "APP",
                
                createCellForUIColor(preferences.settingBackgroundColor, title: "Background") { [weak self] in
                    guard let `self` = self else { return }
                    AppDelegate.rootViewController.view.backgroundColor     = self.preferences.settingBackgroundColor.value
                    self.view.backgroundColor                               = AppDelegate.rootViewController.view.backgroundColor
                },
                
                createCellForUISwitch(preferences.settingAudioOn, title: "Audio"),

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
        
        cell.selectedBackgroundView = UIView.createWithBackgroundColor(Store.Manager.settingsGetSelectionColor())
        
        return cell
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        Store.Manager.synchronize()
        
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        tableView.backgroundColor   = preferences.settingBackgroundColor.value
        
        colorForHeaderText          = preferences.settingTabSettingsHeaderTextColor.value
        colorForFooterText          = preferences.settingTabSettingsFooterTextColor.value
        
        super.viewWillAppear(animated)
    }

    
    
}
