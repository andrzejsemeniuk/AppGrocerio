//
//  Preferences.swift
//  productGroceries
//
//  Created by andrzej semeniuk on 8/1/17.
//  Copyright © 2017 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit
import ASToolkit

func object<Type>(_ object:Any, dataMembersOfType type:Type) -> [Type] {
    var result = [Type]()
    for child in Mirror(reflecting: object).children {
        if let setting = child.value as? Type {
            result.append(setting)
        }
    }
    return result
    
}

class Preferences : GenericManagerOfSettings {
    
    func synchronize() {
        UserDefaults.standard.synchronize()
    }
    
//    lazy var manager = GenericManagerStore {
//        let result = GenericManagerStoreFromNSUserDefaults()
//        return result
//    }()
    
    init() {
        
//        for setting in object(self,dataMembersOfType:GenericSetting.self) {
//            setting.manager = manager
//        }
        
        settingList.reset()
    }
    
    
    var settingBackgroundColor                          = GenericSetting<UIColor>       (key:"settings-background", first:.blue)
    
    var settingAudioOn                                  = GenericSetting<Bool>          (key:"settings-audio-on", first:true)
    var settingSelectionColor                           = GenericSetting<UIColor>       (key:"settings-selection-color", first:.red)
    var settingSelectionColorOpacity                    = GenericSetting<CGFloat>       (key:"settings-selection-color-opacity", first:0.5)
    
    var settingTabSettingsHeaderTextColor               = GenericSetting<UIColor>       (key:"settings-header-text-color", first:.black)
    var settingTabSettingsFooterTextColor               = GenericSetting<UIColor>       (key:"settings-footer-text-color", first:.black)
    
    var settingTabCategoriesUppercase                   = GenericSetting<Bool>          (key:"settings-categories-uppercase", first:false)
    var settingTabCategoriesEmphasize                   = GenericSetting<Bool>          (key:"settings-categories-emphasize", first:true)
    var settingTabCategoriesFont                        = GenericSetting<String>        (key:"settings-categories-font", first:"Arial")
    var settingTabCategoriesFontGrowth                  = GenericSetting<CGFloat>       (key:"settings-categories-font-growth", first:2.0)
    var settingTabCategoriesTheme                       = GenericSetting<String>        (key:"settings-categories-theme", first:"?")
    var settingTabCategoriesTextColor                   = GenericSetting<UIColor>       (key:"settings-categories-text-color", first:.black)
    var settingTabItemsFont                             = GenericSetting<String>        (key:"settings-items-font", first:"Arial")
    var settingTabItemsFontGrowth                       = GenericSetting<CGFloat>       (key:"settings-items-font-growth", first:1.0)
    var settingTabItemsUppercase                        = GenericSetting<Bool>          (key:"settings-items-uppercase", first:false)
    var settingTabItemsEmphasize                        = GenericSetting<Bool>          (key:"settings-items-emphasize", first:false)
    var settingTabItemsFontSameAsCategories             = GenericSetting<Bool>          (key:"settings-items-font-as-categories", first:true)
    var settingTabItemsTextColor                        = GenericSetting<UIColor>       (key:"settings-items-text-color", first:.gray)
    var settingTabItemsTextColorSameAsCategories        = GenericSetting<Bool>          (key:"settings-items-text-color-as-categories", first:true)
    var settingTabItemsRowOddOpacity                    = GenericSetting<CGFloat>       (key:"settings-items-row-odd-alpha", first:0.1)
    var settingTabItemsRowEvenOpacity                   = GenericSetting<CGFloat>       (key:"settings-items-row-even-alpha", first:0.2)
    var settingTabItemsQuantityColorBackground          = GenericSetting<UIColor>       (key:"settings-items-quantity-color-bg", first:.lightGray)
    var settingTabItemsQuantityColorBackgroundOpacity   = GenericSetting<CGFloat>       (key:"settings-items-quantity-color-bg-opacity", first:0.5)
    var settingTabItemsQuantityColorText                = GenericSetting<UIColor>       (key:"settings-items-quantity-color-text", first:.red)
    var settingTabItemsQuantityColorTextSameAsItems     = GenericSetting<Bool>          (key:"settings-items-quantity-color-text-as-items", first:true)
    var settingTabItemsQuantityFont                     = GenericSetting<String>        (key:"settings-items-quantity-font", first:"Arial")
    var settingTabItemsQuantityFontGrowth               = GenericSetting<CGFloat>       (key:"settings-items-quantity-font-growth", first:0.0)
    var settingTabItemsQuantityFontSameAsItems          = GenericSetting<Bool>          (key:"settings-items-quantity-font-as-items", first:true)
    
    var settingTabThemesSolidColor                      = GenericSetting<UIColor>       (key:"settings-themes-solid-color", first:.red)
    var settingTabThemesRangeFromColor                  = GenericSetting<UIColor>       (key:"settings-themes-range-color-from", first:.red)
    var settingTabThemesRangeToColor                    = GenericSetting<UIColor>       (key:"settings-themes-range-color-to", first:.yellow)
    var settingTabThemesCustomColors                    = GenericSetting<Bool>          (key:"settings-themes-custom-colors", first:false)
    var settingTabThemesName                            = GenericSetting<String>        (key:"settings-themes-name", first:"Default")
    var settingTabThemesSaturation                      = GenericSetting<CGFloat>       (key:"settings-themes-saturation", first:1.0)
    
    var settingCurrent                                  = GenericSetting<String>        (key:"settings:current", first:"Default")
    var settingList                                     = GenericSetting<String>        (key:"settings-list", first:"Default,Apple,Charcoal,Grape,Gray,Orange,Plain,Rainbow,Strawberry,Chalkboard") // Clear,Clean,Paper,Princess,School,Draft,Plastik")
    var settingLastName                                 = GenericSetting<String>        (key:"settings-last-name", first:"Default")

}

extension Preferences {
    
    func theme(loadWithName name:String) {
        
        let clear = {
            self.reset(withPrefix:"settingTab")
            self.reset(withPrefix:"settingSelection")
            self.settingAudioOn.reset()
            self.settingBackgroundColor.reset()
        }
        
        switch name {
            case "Default":
            
                clear()
                
                settingTabThemesName                            .value = name
                
                settingBackgroundColor                          .value = UIColor(hue:0.50,saturation:0.60,brightness:1.00)
                
                settingAudioOn                                  .value = true
                settingSelectionColor                           .value = UIColor(hue:0.30,saturation:1.00,brightness:1.00)
                settingSelectionColorOpacity                    .value = 1.00
                
                settingTabSettingsHeaderTextColor               .value = UIColor(hue:0.55,saturation:0.70,brightness:0.75)
                settingTabSettingsFooterTextColor               .value = UIColor(hue:0.55,saturation:0.70,brightness:0.75)
                
                settingTabCategoriesUppercase                   .value = false
                settingTabCategoriesEmphasize                   .value = false
                settingTabCategoriesFont                        .value = "Helvetica-Bold"
                settingTabCategoriesFontGrowth                  .value = 0
//                settingTabCategoriesTheme                       .value =
                settingTabCategoriesTextColor                   .value = UIColor(hue:0,saturation:1,brightness:1)
                settingTabItemsFont                             .value = "Helvetica"
                settingTabItemsFontGrowth                       .value = 0.0
                settingTabItemsUppercase                        .value = false
                settingTabItemsEmphasize                        .value = false
                settingTabItemsFontSameAsCategories             .value = true
                settingTabItemsTextColor                        .value = UIColor(hue:0.0,saturation:1,brightness:1)
                settingTabItemsTextColorSameAsCategories        .value = true
                settingTabItemsRowOddOpacity                    .value = 0.30
                settingTabItemsRowEvenOpacity                   .value = 0.70
                settingTabItemsQuantityColorBackground          .value = UIColor(hue:0,saturation:1,brightness:1)
                settingTabItemsQuantityColorBackgroundOpacity   .value = 1.00
                settingTabItemsQuantityColorText                .value = UIColor(hue:0,saturation:0,brightness:1)
                settingTabItemsQuantityColorTextSameAsItems     .value = true
                settingTabItemsQuantityFont                     .value = "Helvetica-Bold"
                settingTabItemsQuantityFontGrowth               .value = 0.00
                settingTabItemsQuantityFontSameAsItems          .value = true
                
                settingTabThemesSolidColor                      .value = UIColor(hue:0.14)
//                settingTabThemesRangeFromColor                  .value = 
//                settingTabThemesRangeToColor                    .value =
//                settingTabThemesCustomColors                    .value =
                settingTabThemesName                            .value = "Solid"
                settingTabThemesSaturation                      .value = 1.00

                synchronize()

            
        case "Chalkboard":
            
            settingTabThemesName                            .value      = name
            
            settingTabThemesRangeFromColor                  .value      = UIColor(white:0.40,alpha:0.73)
            settingTabThemesRangeToColor                    .value      = UIColor(white:0.40,alpha:0.75)
            settingTabThemesSaturation                      .value      = 0.90
            
            settingTabCategoriesUppercase                   .value      = false
            settingTabCategoriesEmphasize                   .value      = true
            settingTabCategoriesFont                        .value      = "Chalkduster"
            settingTabCategoriesTextColor                   .value      = UIColor(hue:0.40,saturation:0.10,brightness:1.00)
            
            settingTabItemsFont                             .value      = settingTabCategoriesFont.value
            settingTabItemsTextColor                        .value      = UIColor(hue:0.00,saturation:0.00,brightness:0.90)
            settingTabItemsUppercase                        .value      = false
            settingTabItemsEmphasize                        .value      = false
            
            settingTabItemsRowOddOpacity                    .value      = 0.00
            settingTabItemsRowEvenOpacity                   .value      = 0.10
            
            settingTabItemsQuantityColorText                .value      = UIColor(hue:0.00,saturation:0.00,brightness:1.00)
            settingTabItemsQuantityFont                     .value      = settingTabItemsFont.value
            settingTabItemsQuantityColorBackground          .value      = UIColor(hue:0.4,saturation:1,brightness:0.1)
            settingTabItemsQuantityColorBackgroundOpacity   .value      = 0.20
            
            settingSelectionColor                           .value      = UIColor(hue:0.30,saturation:0.80,brightness:1.00)
            settingSelectionColorOpacity                    .value      = 0.50
            
            settingBackgroundColor                          .value      = UIColor(hue:0.40,saturation:1.00,brightness:0.55)
            settingTabSettingsHeaderTextColor               .value      = UIColor(hue:0.85,saturation:0.00,brightness:1.00)
            settingTabSettingsFooterTextColor               .value      = UIColor(hue:0.85,saturation:0.00,brightness:1.00)
            
            synchronize()
            

        default:
            break
        }
    }
    
    func theme(saveWithName name:String) {
        
    }
    
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
