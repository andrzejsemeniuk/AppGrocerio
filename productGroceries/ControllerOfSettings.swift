//
//  ControllerOfSettings.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit
import ASToolkit

class ControllerOfSettings : GenericControllerOfSettings
{
    
    
    var preferences                 : Preferences {
        return AppDelegate.instance.preferences
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource        = self
        
        tableView.delegate          = self
        
        
        tableView.separatorStyle    = .none
        
        tableView.showsVerticalScrollIndicator = false
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
    
    
    

    
    override func reload() {
        preferences.synchronize()
        
        super.reload()
    }
    
    
    
    override open func createCellForUIColor              (_ setting      : GenericSetting<UIColor>,
                                                          title          : String,
                                                          setup          : ((UITableViewCell,IndexPath)->())? = nil,
                                                          setupForPicker : ((GenericControllerOfPickerOfColor)->())? = nil,
                                                          action         : (()->())? = nil) -> FunctionOnCell
    {
        var setupForPicker1 = setupForPicker
        
        if setupForPicker1 == nil {
            setupForPicker1 = { [weak setting] picker in
                picker.flavor = .matrixOfSolidCircles(selected  : setting?.value ?? .white,
                                                      colors    : UIColor.generateMatrixOfColors(columns    : 7,
                                                                                                 rowsOfGray : 2,
                                                                                                 rowsOfHues : 12),
                                                      diameter  : 36,
                                                      space     : 8)
            }
        }
        
        return super.createCellForUIColor(setting, title:title, setup:setup, setupForPicker:setupForPicker1, action:action)
    }

    
    
    
    
    override func createSections() -> [Section]
    {
        return [
            Section(header  : "SETTINGS",
                    footer  : "Save current settings, or load previously saved settings",
                    cells   : [
                        
                        createCellForTapOnInput(title    : "Save As ...",
                                                message  : "Specify name for current settings.",
                                                setup    : { [weak self] cell,indexpath in
                                                    cell.selectionStyle = .default
                                                    cell.accessoryType  = .none
                                                    if let detail = cell.detailTextLabel {
                                                        detail.text = self?.preferences.themeCurrent.value
                                                    }
                        }, value:{ [weak self] in
                            return (self?.preferences.themeCurrent.value ?? "") + "+"
                        }) { [weak self] text in
                            
                            guard let `self` = self else { return }
                            
                            if 0 < text.length {
                                if self.preferences.theme(saveWithCustomName:text) {
                                    self.preferences.themeCurrent.value = text
                                    self.tableView.reloadData()
                                }
                            }
                        },
                        
                        createCellForTap(title: "Load", setup: { cell,indexpath in
                            cell.selectionStyle = .default
                            cell.accessoryType  = .disclosureIndicator
                        }) { [weak self] in
                            
                            guard let `self` = self else { return }
                            
                            let controller = GenericControllerOfList()
                            
                            controller.style = .grouped
                            
                            if 0 < self.preferences.themeArrayOfNamesCustom.count {
                                controller.sections += [
                                    GenericControllerOfList.Section(
                                        header  : "Custom Themes",
                                        footer  : "A list of themes created by you",
                                        items   : self.preferences.themeArrayOfNamesCustom
                                )]
                            }
                            
                            controller.sections += [
                                GenericControllerOfList.Section(
                                    header  : "Predefined Themes",
                                    footer  : "A list of standard themes",
                                    items   : self.preferences.themeArrayOfNamesPredefined
                                )
                            ]
                            
                            controller.handlerForIsEditableAtIndexPath = { controller,path in
                                return path.section == 0
                            }
                            
                            controller.selected = self.preferences.themeCurrent.value
                            
                            controller.handlerForDidSelectRowAtIndexPath = { [weak self] controller, indexPath in
                                guard let `self` = self else { return }
                                if let selected = controller.item(at:indexPath) {
                                    self.preferences.theme(loadWithName:selected)
                                    AppDelegate.rootViewController.view.backgroundColor = self.preferences.settingBackgroundColor.value
                                    controller.navigationController?.popViewController(animated: true)
                                }
                            }
                            
                            controller.handlerForCommitEditingStyle = { [weak self] controller, commitEditingStyle, indexPath in
                                guard
                                    let `self` = self,
                                    commitEditingStyle == .delete
                                    else {
                                        return false
                                }
                                // TODO: TEST
                                if let selected = controller.item(at:indexPath), indexPath.section == 0 {
                                    return self.preferences.theme(removeCustomWithName:selected)
                                }
                                return false
                            }
                            
                            self.navigationController?.pushViewController(controller, animated:true)
                            
                        },
                        
                        createCellForUIColor(preferences.settingTabSettingsTextColor, title: "Header/Footer Text Color") { [weak self] in
                            self?.reload()
                        },
                        
                ]),
            
            Section(header  : "APP",
                    footer  : "Set app properties",
                    cells   : [
                        
                        createCellForUIColor(preferences.settingBackgroundColor, title: "Background") { [weak self] in
                            self?.preferences.synchronize()
                        },
                        
                        createCellForUIColor(preferences.settingBarBackgroundColor, title: "Bar Background Color") { [weak self] in
                            self?.preferences.synchronize()
                        },
                        
                        createCellForUIColor(preferences.settingBarItemSelectedTintColor, title: "Bar Item Selected Color") { [weak self] in
                            self?.preferences.synchronize()
                        },
                        
                        createCellForUIColor(preferences.settingBarItemUnselectedTintColor, title: "Bar Item Unselected Color") { [weak self] in
                            self?.preferences.synchronize()
                        },
                        
                        createCellForUIColor(preferences.settingBarTitleColor, title: "Bar Title Color") { [weak self] in
                            self?.preferences.synchronize()
                        },
                        
                        createCellForUIFontName(preferences.settingBarTitleFont, title: "Bar Title Font") { [weak self] in
                            self?.preferences.synchronize()
                        },
                        
                        createCellForUISwitch(preferences.settingAudioOn, title: "Audio"),
                        
                        ]),
            
            Section(header  : "CATEGORIES",
                    footer  : "",
                    cells   : [
                        
                        createCellForUIFontName (preferences.settingTabCategoriesFont, title: "Font"),
                        
                        createCellForUIColor(preferences.settingTabCategoriesTextColor, title: "Color"),
                        
                        createCellForUISwitch(preferences.settingTabCategoriesUppercase, title: "Uppercase"),
                        
                        createCellForUISwitch(preferences.settingTabCategoriesEmphasize, title: "Emphasize"),
                        
                        createCellForTap(title: "Background", setup: { [weak self] cell,path in
                            if let detail = cell.detailTextLabel {
                                detail.text = self?.preferences.settingTabThemesName.value
                            }
                        }) {
                            AppDelegate.navigatorForSettings.pushViewController(ControllerOfThemes(), animated:true)
                        }
                        
                ]),
            
            Section(header  : "",
                    footer  : "If you deleted any categories manually, you can re-add them all with Rebuild",
                    cells   : [
                        
                        createCellForTap(title: "Rebuild") { [weak self] in
                            self?.rebuild()
                        }
                        
                ]),
            
            Section(header  : "ITEM TEXT",
                    footer  : "",
                    cells   : [
                        
                        createCellForUIFontName(preferences.settingTabItemsFont, title: "Font"),
                        
                        createCellForUISwitch(preferences.settingTabItemsFontSameAsCategories, title: "  Same as Categories"),
                        
                        createCellForUIColor(preferences.settingTabItemsTextColor, title:"Color"),
                        
                        createCellForUISwitch(preferences.settingTabItemsTextColorSameAsCategories, title: "  Same as Categories"),
                        
                        createCellForUISwitch(preferences.settingTabItemsUppercase, title: "Uppercase"),
                        
                        createCellForUISwitch(preferences.settingTabItemsEmphasize, title: "Emphasize"),
                        
                        ]),
            
            Section(header  : "ITEM ROW OPACITY",
                    footer  : "Make the background color of an item row stand out or fade.",
                    cells   : [
                        
                        createCellForUISlider(preferences.settingTabItemsRowEvenOpacity, title: "Even"),
                        
                        createCellForUISlider(preferences.settingTabItemsRowOddOpacity, title: "Odd"),
                        
                        ]),
            
            
            Section(header  : "ITEM QUANTITY",
                    footer  : "",
                    cells   : [
                        
                        createCellForUIFontName(preferences.settingTabItemsQuantityFont, title: "Font"),
                        
                        createCellForUISwitch(preferences.settingTabItemsQuantityFontSameAsItems, title: "  Same as Items"),
                        
                        createCellForUIColor(preferences.settingTabItemsQuantityColorText, title: "Color"),
                        
                        createCellForUISwitch(preferences.settingTabItemsQuantityColorTextSameAsItems, title: "  Same as Items"),
                        
                        createCellForUIColor(preferences.settingTabItemsQuantityColorBackground , title: "Background"),
                        
                        createCellForUISlider(preferences.settingTabItemsQuantityColorBackgroundOpacity, title: "  Opacity"),

                        createCellForTapOnChoice(title:"  Shape", message:"Choose a quantity background shape.", choices:{ ["Square","Circle"] }, setup:{ [weak self] cell,path in
                            if let detail = cell.detailTextLabel, let `self` = self {
                                detail.text = self.preferences.settingTabItemsQuantityCircle.value ? "Circle" : "Square"
                            }
                        }) { [weak self] choice in
                            switch choice {
                                case "Square":
                                    self?.preferences.settingTabItemsQuantityCircle.value = false
                                default:
                                    self?.preferences.settingTabItemsQuantityCircle.value = true
                            }
                            self?.tableView.reloadData()
                        }
                ]),
            
//            Section(header  : "SELECTION",
//                    footer  : "Set selection properties for rows on all tabs",
//                    cells   : [
//                        
//                        createCellForUIColor(preferences.settingSelectionColor, title: "Background"),
//                        
//                        createCellForUISlider(preferences.settingSelectionColorOpacity, title: "Opacity"),
//                        
//                        ]),
            
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
        
        cell.selectedBackgroundView = UIView.create(withBackgroundColor:Store.Manager.settingsGetSelectionColor())
        
        return cell
    }
    
    override func viewWillDisappear             (_ animated: Bool)
    {
        Store.Manager.synchronize()
        
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear                (_ animated: Bool)
    {
        tableView.backgroundColor   = preferences.settingBackgroundColor.value
        
        colorForHeaderText          = preferences.settingTabSettingsTextColor.value
        colorForFooterText          = colorForHeaderText
        
        tableView.reloadData()
        
        super.viewWillAppear(animated)
    }
    
    
    
}
