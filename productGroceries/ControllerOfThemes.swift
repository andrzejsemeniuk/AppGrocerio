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
                createCellForUISlider(preferences.settingTabThemesSaturation, title: "Saturation"),
            ]))
        
        
        sections.append(
            Section(header : "DYNAMIC THEMES",
                    footer : "",
                    cells  : [
                
                definePredefinedThemeWithName("Solid"),
                
                createCellForUIColor(preferences.settingTabThemesSolidColor, title:"  Color"),
                
                createCellForUISlider(preferences.settingTabThemesSolidOddOpacity, title: "  Odd Opacity"),
                
                createCellForUISlider(preferences.settingTabThemesSolidEvenOpacity, title: "  Even Opacity"),
                        
                definePredefinedThemeWithName("Range"),
                
                createCellForUIColor(preferences.settingTabThemesRangeFromColor, title:"  Color From"),
                
                createCellForUIColor(preferences.settingTabThemesRangeToColor, title:"  Color To"),

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
