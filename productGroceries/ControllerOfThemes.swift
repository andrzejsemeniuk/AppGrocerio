//
//  SettingsController.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class ControllerOfThemes : GenericControllerOfSettings
{
    
    override func viewDidLoad()
    {
        tableView               = UITableView(frame:tableView.frame,style:.grouped)
        
        tableView.dataSource    = self
        
        tableView.delegate      = self
        
        tableView.separatorStyle = .none
        
        self.title              = "Theme"
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func createRows() -> [[Any]]
    {
        var rows = [[Any]]()
        
        var CATEGORIES = [Any]()
        
        if false
        {
            CATEGORIES.append(" ")
            
            let count = ControllerOfCategories.instance.categories.count
            
            for row in 0..<count {
                
                let ROW = row
                
                CATEGORIES.append(
                    { (cell:UITableViewCell, indexPath:IndexPath) in
                        ControllerOfCategories.instance.styleCell(cell: cell,indexPath:IndexPath(row:ROW, section:0))
                        
                        cell.selectionStyle = .none
                })
            }
            
            CATEGORIES.append(" ")
        }
        
        
        let definePredefinedThemeWithName = { (name:String) -> Any in
            return { (cell:UITableViewCell, indexPath:IndexPath) in
                if let label = cell.textLabel {
                    cell.selectionStyle = .default
                    label.text          = name
                    self.addAction(indexPath: indexPath) {
                        Data.Manager.settingsSetThemeWithName(name)
                        self.reload()
                    }
                }
                if Data.Manager.settingsGetThemeName() == name {
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
                
                { (cell:UITableViewCell, indexPath:IndexPath) in
//                    let slider = self.registerSlider(Data.Manager.settingsGetFloatForKey(.SettingsTabThemesSaturation, defaultValue:0.4), update: { (myslider:UISlider) in
//                        Data.Manager.settingsSetFloat(myslider.value, forKey:.SettingsTabThemesSaturation)
//                    })
//                    let W:CGFloat = AppDelegate.rootViewController.view.bounds.width
//                    let w:CGFloat = W/2.0
//                    cell.frame  = CGRectMake(W/2.0-w,0,w,cell.bounds.height)
//                    cell.addSubview(slider)
                    if let label = cell.textLabel {
                        label.text          = "Saturation"
                        cell.accessoryView  = self.registerSlider(value: Data.Manager.settingsGetFloatForKey(.SettingsTabThemesSaturation, defaultValue:0.4), update: { (myslider:UISlider) in
                            Data.Manager.settingsSetFloat(myslider.value, forKey:.SettingsTabThemesSaturation)
                        })
                        cell.accessoryType  = .none
                        cell.selectionStyle = .default
                    }
                },
                
                
                ""
            ])
        
        rows.append(
            [
                "PREDEFINED THEMES",
                
                definePredefinedThemeWithName("Apple"),
                definePredefinedThemeWithName("Charcoal"),
                definePredefinedThemeWithName("Grape"),
                definePredefinedThemeWithName("Gray"),
                definePredefinedThemeWithName("Orange"),
                definePredefinedThemeWithName("Plain"),
                definePredefinedThemeWithName("Rainbow"),
                definePredefinedThemeWithName("Strawberry"),
                
                ""
            ])
        
        rows.append(
            [
                "DYNAMIC THEMES",
                
                definePredefinedThemeWithName("Solid"),
                
                createCellForColor(color0: Data.Manager.settingsGetThemesSolidColor(),name:"  Color",title:"Solid",key:.SettingsTabThemesSolidColor) {
//                        self.reload()
                },
                
                definePredefinedThemeWithName("Range"),
                
                createCellForColor(color0: Data.Manager.settingsGetThemesRangeFromColor(),name:"  Color From",title:"Range From",key:.SettingsTabThemesRangeFromColor) {
//                        self.reload()
                },
                createCellForColor(color0: Data.Manager.settingsGetThemesRangeToColor(),name:"  Color To",title:"Range To",key:.SettingsTabThemesRangeToColor) {
//                        self.reload()
                },
                
                ""
            ])
        
        return rows
    }
    
}
