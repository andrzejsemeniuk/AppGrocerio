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
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func createSections() -> [Section]
    {
        var sections = [Section]()
        
        let definePredefinedThemeWithName = { (name:String) -> FunctionOnCell in
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
        
        sections    = []
        
        sections.append(Section(
            header : "",
            footer : "",
            cells  : [
                createCellForUISlider(AppDelegate.instance.preferences.settingTabThemesSaturation, title: "Saturation"),
            ]))
        
        
        sections.append(
            Section(header : "DYNAMIC THEMES",
                    footer : "",
                    cells  : [
                
                definePredefinedThemeWithName("Solid"),
                
                //                createCellForUIColor(Store.Manager.settingsGetThemesSolidColor(),name:"  Color",title:"Solid",key:.SettingsTabThemesSolidColor) {
                //                },
                
                definePredefinedThemeWithName("Range")
                
                //                createCellForUIColor(Store.Manager.settingsGetThemesRangeFromColor(),name:"  Color From",title:"Range From",key:.SettingsTabThemesRangeFromColor) {
                //                },
                //                createCellForUIColor(Store.Manager.settingsGetThemesRangeToColor(),name:"  Color To",title:"Range To",key:.SettingsTabThemesRangeToColor) {
                //                },
            ]))

        let customThemeNames = preferences.themeArrayOfNamesCustom
        
        if 0 < customThemeNames.count {
            
            var section = Section(header : "CUSTOM THEMES",
                                  footer : "")
            
            for themeName in customThemeNames {
                section.cells.append(definePredefinedThemeWithName(themeName))
            }
            
            sections.append(section)
        }
        
        if true {
        
            var section = Section(header : "PREDEFINED THEMES",
                                  footer : "")
            
            for themeName in preferences.themeArrayOfNamesPredefined {
                section.cells.append(definePredefinedThemeWithName(themeName))
            }
            
            sections.append(section)
        }
        
        return sections
    }
    
}
