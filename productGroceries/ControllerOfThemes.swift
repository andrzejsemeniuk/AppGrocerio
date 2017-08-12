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

class ControllerOfThemes : GenericControllerOfSettings
{
    
    
    var preferences             : Preferences {
        return AppDelegate.instance.preferences
    }


    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource    = self
        
        tableView.delegate      = self
        
        tableView.separatorStyle = .none
        
        self.title              = "Theme"
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func createRows() -> [[Any]]
    {
        var rows = [[Any]]()
        
        var CATEGORIES = [Any]()
        
        let definePredefinedThemeWithName = { (name:String) -> Any in
            return { [weak self] (cell:UITableViewCell, indexPath:IndexPath) in
                if let label = cell.textLabel {
                    cell.selectionStyle = .default
                    label.text          = name
                    self?.addAction(indexPath: indexPath) {
                        self?.preferences.settingTabThemesName.value = name
                        self?.reload()
                    }
                }
                if self?.preferences.settingTabThemesName.value == name {
                    cell.accessoryType = .checkmark
                }
                else {
                    cell.accessoryType = .none
                }
            }
        }
        
        rows    = []
        
        if 0 < CATEGORIES.count {
            rows.append(CATEGORIES)
        }

        rows.append(
            [
                "", //"PREDEFINED THEME SATURATION",
                
                createCellForUISlider(AppDelegate.instance.preferences.settingTabThemesSaturation, title: "Saturation"),                
                
                ""
            ])
        
        
        rows.append(
            [
                "DYNAMIC THEMES",
                
                definePredefinedThemeWithName("Solid"),
                
                //                createCellForUIColor(Store.Manager.settingsGetThemesSolidColor(),name:"  Color",title:"Solid",key:.SettingsTabThemesSolidColor) {
                //                },
                
                definePredefinedThemeWithName("Range"),
                
                //                createCellForUIColor(Store.Manager.settingsGetThemesRangeFromColor(),name:"  Color From",title:"Range From",key:.SettingsTabThemesRangeFromColor) {
                //                },
                //                createCellForUIColor(Store.Manager.settingsGetThemesRangeToColor(),name:"  Color To",title:"Range To",key:.SettingsTabThemesRangeToColor) {
                //                },
                
                ""
            ])

        let customThemeNames = preferences.themeArrayOfNamesCustom
        
        if 0 < customThemeNames.count {
            
            var section = [Any]()
            
            section.append("CUSTOM THEMES")
            
            for themeName in customThemeNames {
                section.append(definePredefinedThemeWithName(themeName))
            }
            
            section.append("")
            
            rows.append(section)
        }
        
        if true {
        
            var section = [Any]()
            
            section.append("PREDEFINED THEMES")
            
            for themeName in preferences.themeArrayOfNamesPredefined {
                section.append(definePredefinedThemeWithName(themeName))
            }
            
            section.append("")
            
            rows.append(section)
        }
        
        return rows
    }
    
}
