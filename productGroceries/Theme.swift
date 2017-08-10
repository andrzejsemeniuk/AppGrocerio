//
//  Theme.swift
//  productGroceries
//
//  Created by andrzej semeniuk on 8/9/17.
//  Copyright © 2017 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class Theme {
    
    enum Style {
        case custom(name:String)
        
        case apple
        case basic
    }
    
    var name : String = "?"
    let style : Style
    
    
    
    var colorForCategoryIndex:(Int) -> UIColor = { index in
        return UIColor.white
    }
    
    
    init(withStyle style:Style) {
        self.style = style
    }

    func add() {
        // to preferences
    }
    
    func remove() {
        // from preferences
    }
    
    func update() {
        // to preferences
    }
    
    func load() {
        // from preferences
    }
    
    func predefine()
    {
        /*
        do
        {
            _ = settingsUse                             ("Chalkboard")
            
            settingsSetThemesRangeFromColor             (UIColor(white:0.40,alpha:0.73))
            settingsSetThemesRangeToColor               (UIColor(white:0.40,alpha:0.75))
            settingsSetFloat                            (0.90                                               ,forKey:.SettingsTabThemesSaturation)
            settingsSetThemeWithName                    ("Range")
            
            settingsSetBool                             (false                                              ,forKey:.SettingsTabCategoriesUppercase)
            settingsSetBool                             (true                                               ,forKey:.SettingsTabCategoriesEmphasize)
            settingsSetString                           ("Chalkduster"                                      ,forKey:.SettingsTabCategoriesFont)
            settingsSetColor                            (UIColor(hue:0.40,saturation:0.10,brightness:1.00)  ,forKey:.SettingsTabCategoriesTextColor)
            
            settingsSetString                           ("Chalkduster"                                      ,forKey:.SettingsTabItemsFont)
            settingsSetColor                            (UIColor(hue:0.00,saturation:0.00,brightness:0.90)  ,forKey:.SettingsTabItemsTextColor)
            settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsUppercase)
            settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsEmphasize)
            
            settingsSetFloat                            (0.00                                               ,forKey:.SettingsTabItemsRowOddOpacity)
            settingsSetFloat                            (0.10                                               ,forKey:.SettingsTabItemsRowEvenOpacity)
            
            settingsSetColor                            (UIColor(hue:0.00,saturation:0.00,brightness:1.00)  ,forKey:.SettingsTabItemsQuantityColorText)
            settingsSetString                           ("Chalkduster"                                      ,forKey:.SettingsTabItemsQuantityFont)
            settingsSetColor                            (UIColor(hue:0.4,saturation:1,brightness:0.1)       ,forKey:.SettingsTabItemsQuantityColorBackground)
            settingsSetFloat                            (0.20                                               ,forKey:.SettingsTabItemsQuantityColorBackgroundOpacity)
            
            settingsSetColor                            (UIColor(hue:0.30,saturation:0.80,brightness:1.00)  ,forKey:.SettingsSelectionColor)
            settingsSetFloat                            (0.50                                               ,forKey:.SettingsSelectionColorOpacity)
            
            settingsSetColor                            (UIColor(white:0.40,alpha:0.60)                  ,forKey:.SettingsBackgroundColor)
            settingsSetColor                            (UIColor(hue:0.85,saturation:0.00,brightness:1.00)  ,forKey:.SettingsTabSettingsHeaderTextColor)
            settingsSetColor                            (UIColor(hue:0.85,saturation:0.00,brightness:1.00)  ,forKey:.SettingsTabSettingsFooterTextColor)
            
            _ = settingsSave                            ("Chalkboard")
        }
        
        
        do
        {
            _ = settingsUse                             ("Honey")
            
            settingsSetThemesRangeFromColor             (UIColor(white:0.10,alpha:1.00))
            settingsSetThemesRangeToColor               (UIColor(white:0.13,alpha:1.00))
            settingsSetFloat                            (1.00                                               ,forKey:.SettingsTabThemesSaturation)
            settingsSetThemeWithName                    ("Range")
            
            settingsSetBool                             (false                                              ,forKey:.SettingsTabCategoriesUppercase)
            settingsSetBool                             (true                                               ,forKey:.SettingsTabCategoriesEmphasize)
            settingsSetString                           ("Noteworthy-Bold"                                  ,forKey:.SettingsTabCategoriesFont)
            settingsSetColor                            (UIColor(hue:0.06,saturation:1.00,brightness:1.00)  ,forKey:.SettingsTabCategoriesTextColor)
            
            settingsSetString                           ("Noteworthy-Bold"                                  ,forKey:.SettingsTabItemsFont)
            settingsSetColor                            (UIColor(hue:0.10,saturation:0.40,brightness:1.00)  ,forKey:.SettingsTabItemsTextColor)
            settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsUppercase)
            settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsEmphasize)
            
            settingsSetFloat                            (0.00                                               ,forKey:.SettingsTabItemsRowOddOpacity)
            settingsSetFloat                            (0.20                                               ,forKey:.SettingsTabItemsRowEvenOpacity)
            
            settingsSetColor                            (UIColor(hue:0.10,saturation:0.40,brightness:1.00)  ,forKey:.SettingsTabItemsQuantityColorText)
            settingsSetString                           ("Noteworthy-Bold"                                  ,forKey:.SettingsTabItemsQuantityFont)
            settingsSetColor                            (UIColor(hue:0.15,saturation:1.00,brightness:0.30)  ,forKey:.SettingsTabItemsQuantityColorBackground)
            settingsSetFloat                            (0.10                                               ,forKey:.SettingsTabItemsQuantityColorBackgroundOpacity)
            
            settingsSetColor                            (UIColor(hue:0.00,saturation:0.80,brightness:1.00)  ,forKey:.SettingsSelectionColor)
            settingsSetFloat                            (0.50                                               ,forKey:.SettingsSelectionColorOpacity)
            
            settingsSetColor                            (UIColor(white:0.08,alpha:1.00)                  ,forKey:.SettingsBackgroundColor)
            settingsSetColor                            (UIColor(hue:0.85,saturation:0.00,brightness:1.00)  ,forKey:.SettingsTabSettingsHeaderTextColor)
            settingsSetColor                            (UIColor(hue:0.85,saturation:0.00,brightness:1.00)  ,forKey:.SettingsTabSettingsFooterTextColor)
            
            _ = settingsSave                            ("Honey")
        }
        
        
        do
        {
            let growth:Float = 4
            
            _ = settingsUse                             ("Pink")
            
            settingsSetThemesRangeFromColor             (UIColor(white:0.90,alpha:1.00))
            settingsSetThemesRangeToColor               (UIColor(white:0.93,alpha:1.00))
            settingsSetFloat                            (1.00                                               ,forKey:.SettingsTabThemesSaturation)
            settingsSetThemeWithName                    ("Range")
            
            settingsSetBool                             (false                                              ,forKey:.SettingsTabCategoriesUppercase)
            settingsSetBool                             (true                                               ,forKey:.SettingsTabCategoriesEmphasize)
            settingsSetString                           ("SnellRoundhand-Black"                             ,forKey:.SettingsTabCategoriesFont)
            settingsSetFloat                            (growth                                             ,forKey:.SettingsTabCategoriesFontGrowth)
            settingsSetColor                            (UIColor(hue:0.85,saturation:0.30,brightness:1.00)  ,forKey:.SettingsTabCategoriesTextColor)
            
            settingsSetString                           ("SnellRoundhand-Bold"                              ,forKey:.SettingsTabItemsFont)
            settingsSetFloat                            (growth                                             ,forKey:.SettingsTabItemsFontGrowth)
            settingsSetColor                            (UIColor(hue:0.80,saturation:0.30,brightness:1.00)  ,forKey:.SettingsTabItemsTextColor)
            settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsUppercase)
            settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsEmphasize)
            
            settingsSetFloat                            (0.00                                               ,forKey:.SettingsTabItemsRowOddOpacity)
            settingsSetFloat                            (0.20                                               ,forKey:.SettingsTabItemsRowEvenOpacity)
            
            settingsSetColor                            (UIColor(hue:0.80,saturation:0.20,brightness:1.00)  ,forKey:.SettingsTabItemsQuantityColorText)
            settingsSetString                           ("SnellRoundhand-Black"                             ,forKey:.SettingsTabItemsQuantityFont)
            settingsSetFloat                            (growth + 1                                         ,forKey:.SettingsTabItemsQuantityFontGrowth)
            settingsSetColor                            (UIColor(hue:0.85,saturation:1.00,brightness:0.50)  ,forKey:.SettingsTabItemsQuantityColorBackground)
            settingsSetFloat                            (0.50                                               ,forKey:.SettingsTabItemsQuantityColorBackgroundOpacity)
            
            settingsSetColor                            (UIColor(hue:0.51,saturation:0.20,brightness:1.00)  ,forKey:.SettingsSelectionColor)
            settingsSetFloat                            (0.30                                               ,forKey:.SettingsSelectionColorOpacity)
            
            settingsSetColor                            (UIColor(hue:0.90,saturation:1.00,brightness:1.00)  ,forKey:.SettingsBackgroundColor)
            settingsSetColor                            (UIColor(hue:0.85,saturation:0.00,brightness:1.00)  ,forKey:.SettingsTabSettingsHeaderTextColor)
            settingsSetColor                            (UIColor(hue:0.85,saturation:0.00,brightness:1.00)  ,forKey:.SettingsTabSettingsFooterTextColor)
            
            _ = settingsSave                            ("Pink")
        }
        
        
        do
        {
            let growth:Float = 4
            
            _ = settingsUse                             ("Sky")
            
            settingsSetThemesRangeFromColor             (UIColor(white:0.57,alpha:1.00))
            settingsSetThemesRangeToColor               (UIColor(white:0.60,alpha:1.00))
            settingsSetFloat                            (1.00                                               ,forKey:.SettingsTabThemesSaturation)
            settingsSetThemeWithName                    ("Range")
            
            settingsSetBool                             (false                                              ,forKey:.SettingsTabCategoriesUppercase)
            settingsSetBool                             (false                                              ,forKey:.SettingsTabCategoriesEmphasize)
            settingsSetString                           ("GillSans-LightItalic"                             ,forKey:.SettingsTabCategoriesFont)
            settingsSetFloat                            (growth + 1                                         ,forKey:.SettingsTabCategoriesFontGrowth)
            settingsSetColor                            (UIColor(hue:0.65,saturation:0.30,brightness:1.00)  ,forKey:.SettingsTabCategoriesTextColor)
            
            settingsSetString                           ("GillSans-Italic"                                  ,forKey:.SettingsTabItemsFont)
            settingsSetFloat                            (growth                                             ,forKey:.SettingsTabItemsFontGrowth)
            settingsSetColor                            (UIColor(hue:0.60,saturation:0.30,brightness:1.00)  ,forKey:.SettingsTabItemsTextColor)
            settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsUppercase)
            settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsEmphasize)
            
            settingsSetFloat                            (0.00                                               ,forKey:.SettingsTabItemsRowOddOpacity)
            settingsSetFloat                            (0.20                                               ,forKey:.SettingsTabItemsRowEvenOpacity)
            
            settingsSetColor                            (UIColor(hue:0.60,saturation:0.20,brightness:1.00)  ,forKey:.SettingsTabItemsQuantityColorText)
            settingsSetString                           ("GillSans-BoldItalic"                              ,forKey:.SettingsTabItemsQuantityFont)
            settingsSetFloat                            (growth                                             ,forKey:.SettingsTabItemsQuantityFontGrowth)
            settingsSetColor                            (UIColor(hue:0.58,saturation:1.00,brightness:0.80)  ,forKey:.SettingsTabItemsQuantityColorBackground)
            settingsSetFloat                            (0.70                                               ,forKey:.SettingsTabItemsQuantityColorBackgroundOpacity)
            
            settingsSetColor                            (UIColor(hue:0.06,saturation:1.00,brightness:1.00)  ,forKey:.SettingsSelectionColor)
            settingsSetFloat                            (1.00                                               ,forKey:.SettingsSelectionColorOpacity)
            
            settingsSetColor                            (UIColor(hue:0.60,saturation:0.80,brightness:1.00)  ,forKey:.SettingsBackgroundColor)
            settingsSetColor                            (UIColor(hue:0.65,saturation:0.00,brightness:1.00)  ,forKey:.SettingsTabSettingsHeaderTextColor)
            settingsSetColor                            (UIColor(hue:0.65,saturation:0.00,brightness:1.00)  ,forKey:.SettingsTabSettingsFooterTextColor)
            
            _ = settingsSave                            ("Sky")
        }
        
        
        do
        {
            let growth:Float = 1
            
            _ = settingsUse                             ("Charcoal")
            
            settingsSetFloat                            (0.00                                               ,forKey:.SettingsTabThemesSaturation)
            settingsSetThemeWithName                    ("Charcoal")
            
            settingsSetBool                             (false                                              ,forKey:.SettingsTabCategoriesUppercase)
            settingsSetBool                             (false                                              ,forKey:.SettingsTabCategoriesEmphasize)
            settingsSetString                           ("GillSans"                                         ,forKey:.SettingsTabCategoriesFont)
            settingsSetFloat                            (growth                                             ,forKey:.SettingsTabCategoriesFontGrowth)
            settingsSetColor                            (UIColor(hue:0.00,saturation:0.00,brightness:0.80)  ,forKey:.SettingsTabCategoriesTextColor)
            
            settingsSetString                           ("GillSans-Italic"                                  ,forKey:.SettingsTabItemsFont)
            settingsSetFloat                            (growth                                             ,forKey:.SettingsTabItemsFontGrowth)
            settingsSetColor                            (UIColor(hue:0.00,saturation:0.00,brightness:0.90)  ,forKey:.SettingsTabItemsTextColor)
            settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsUppercase)
            settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsEmphasize)
            
            settingsSetFloat                            (0.00                                               ,forKey:.SettingsTabItemsRowOddOpacity)
            settingsSetFloat                            (0.40                                               ,forKey:.SettingsTabItemsRowEvenOpacity)
            
            settingsSetColor                            (UIColor(hue:0.00,saturation:0.00,brightness:0.00)  ,forKey:.SettingsTabItemsQuantityColorText)
            settingsSetString                           ("GillSans"                                         ,forKey:.SettingsTabItemsQuantityFont)
            settingsSetFloat                            (growth + 1                                         ,forKey:.SettingsTabItemsQuantityFontGrowth)
            settingsSetColor                            (UIColor(hue:0.10,saturation:1.00,brightness:1.00)  ,forKey:.SettingsTabItemsQuantityColorBackground)
            settingsSetFloat                            (1.00                                               ,forKey:.SettingsTabItemsQuantityColorBackgroundOpacity)
            
            settingsSetColor                            (UIColor(hue:0.00,saturation:1.00,brightness:1.00)  ,forKey:.SettingsSelectionColor)
            settingsSetFloat                            (1.00                                               ,forKey:.SettingsSelectionColorOpacity)
            
            settingsSetColor                            (UIColor(hue:0.00,saturation:0.00,brightness:0.30)  ,forKey:.SettingsBackgroundColor)
            settingsSetColor                            (UIColor(hue:0.00,saturation:0.00,brightness:0.60)  ,forKey:.SettingsTabSettingsHeaderTextColor)
            settingsSetColor                            (UIColor(hue:0.00,saturation:0.00,brightness:0.60)  ,forKey:.SettingsTabSettingsFooterTextColor)
            
            _ = settingsSave                            ("Charcoal")
        }
        
        
        do
        {
            let growth:Float = 0
            
            _ = settingsUse                             ("Default")
            
            settingsSetBool                             (false                                              ,forKey:.SettingsTabCategoriesUppercase)
            settingsSetBool                             (false                                              ,forKey:.SettingsTabCategoriesEmphasize)
            settingsSetString                           ("Helvetica-Bold"                                   ,forKey:.SettingsTabCategoriesFont)
            settingsSetFloat                            (growth                                             ,forKey:.SettingsTabCategoriesFontGrowth)
            settingsSetColor                            (UIColor(hue:0,saturation:1,brightness:1)           ,forKey:.SettingsTabCategoriesTextColor)
            
            settingsSetThemesSolidColor                 (UIColor(hue:0.14))
            settingsSetFloat                            (1.00                                               ,forKey:.SettingsTabThemesSaturation)
            settingsSetThemeWithName                    ("Solid")
            
            
            settingsSetString                           ("Helvetica"                                        ,forKey:.SettingsTabItemsFont)
            settingsSetFloat                            (growth                                             ,forKey:.SettingsTabItemsFontGrowth)
            settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsUppercase)
            settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsEmphasize)
            settingsSetColor                            (UIColor(hue:0.0,saturation:1,brightness:1)         ,forKey:.SettingsTabItemsTextColor)
            settingsSetFloat                            (0.30                                               ,forKey:.SettingsTabItemsRowOddOpacity)
            settingsSetFloat                            (0.70                                               ,forKey:.SettingsTabItemsRowEvenOpacity)
            
            settingsSetColor                            (UIColor(hue:0,saturation:1,brightness:1)           ,forKey:.SettingsTabItemsQuantityColorBackground)
            settingsSetFloat                            (1.00                                               ,forKey:.SettingsTabItemsQuantityColorBackgroundOpacity)
            settingsSetColor                            (UIColor(hue:0,saturation:0,brightness:1)           ,forKey:.SettingsTabItemsQuantityColorText)
            settingsSetString                           ("Helvetica-Bold"                                   ,forKey:.SettingsTabItemsQuantityFont)
            settingsSetFloat                            (growth                                             ,forKey:.SettingsTabItemsQuantityFontGrowth)
            
            settingsSetColor                            (UIColor(hue:0.30,saturation:1.00,brightness:1.00)  ,forKey:.SettingsSelectionColor)
            settingsSetFloat                            (1.00                                               ,forKey:.SettingsSelectionColorOpacity)
            
            settingsSetColor                            (UIColor(hue:0.50,saturation:0.60,brightness:1.00)  ,forKey:.SettingsBackgroundColor)
            settingsSetColor                            (UIColor(hue:0.55,saturation:0.70,brightness:0.75)  ,forKey:.SettingsTabSettingsHeaderTextColor)
            settingsSetColor                            (UIColor(hue:0.55,saturation:0.70,brightness:0.75)  ,forKey:.SettingsTabSettingsFooterTextColor)
            
            _ = settingsSave                            ("Default")
        }
*/
        
    }
}
