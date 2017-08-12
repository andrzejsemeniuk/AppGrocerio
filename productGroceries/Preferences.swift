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

// TODO: MODIFY GENERIC CONTROLLER OF SETTINGS TO USE SECTION/ROW/CELL STRUCTS?
// TODO: ADD SQUARE|CIRCLE|ROUNDED OPTION FOR QUANTITY BACKGROUND SHAPE
// TODO: CUSTOM-THEME NAMING-CONVENTION AT DISPLAY? [OLD-THEME-NAME]+[NEW-THEME-NAME]
// TODO: ADD THEMES
// TODO: ADD SOUNDS?
// TODO: ADD PROPERTY ANIMATIONS
// TODO: ADD BETTER COLOR PALETTE? A CHOICE OF PALETTES?


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
        for o in object(self, dataMembersOfType: Int(0)) {
            print("\(o)")
        }
        themeListPredefined.reset()
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
    
    var themeCurrent                                    = GenericSetting<String>        (key:"settings:current", first:"Default")
    var themeListPredefined                             = GenericSetting<String>        (key:"settings-list", first:"Default,Apple,Charcoal,Grape,Gray,Honey,Orange,Plain,Pink,Rainbow,Sky,Strawberry,Chalkboard")
    // Red White and Blue,Clear,Clean,Country,Paper,Shakespeare,Poet,Princess,School,Blueprint,Draft,Plastik")
    var themeCustomStorage                     = GenericSetting<Dictionary<String,Dictionary<String,Any>>> (key:"settings-storage", first:[:])
    
    var themeArrayOfNamesPredefined                     : [String] {
        return themeListPredefined.value.split(",").sorted()
    }
    var themeArrayOfNamesCustom                         : [String] {
        return themeCustomStorage.value.keys.sorted()
    }

}

extension Preferences {
    
    func theme(loadWithName name:String) {
        
        let clear = {
            self.reset(withPrefix:"setting")
        }
        
        let name = name.trimmed()
        
        switch name {
            
            case "Default":
            
                clear()
                
                themeCurrent                                    .value = name
                
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

            clear()
            
            themeCurrent                                    .value = name
            
            settingBackgroundColor                          .value = UIColor(hue:0.40,saturation:1.00,brightness:0.55)
            
            settingAudioOn                                  .value = true
            settingSelectionColor                           .value = UIColor(hue:0.30,saturation:0.80,brightness:1.00)
            settingSelectionColorOpacity                    .value = 0.50
            
            settingTabSettingsHeaderTextColor               .value = UIColor.white
            settingTabSettingsFooterTextColor               .value = UIColor.white
            
            settingTabCategoriesUppercase                   .value = false
            settingTabCategoriesEmphasize                   .value = true
            settingTabCategoriesFont                        .value = "Chalkduster"
            settingTabCategoriesFontGrowth                  .value = 0
            settingTabCategoriesTextColor                   .value = UIColor(hue:0.40,saturation:0.10,brightness:1.00)
            
            settingTabItemsFont                             .value = settingTabCategoriesFont.value
            settingTabItemsFontGrowth                       .value = 0.0
            settingTabItemsUppercase                        .value = false
            settingTabItemsEmphasize                        .value = false
            settingTabItemsFontSameAsCategories             .value = true
            settingTabItemsTextColor                        .value = UIColor(hue:0.00,saturation:0.00,brightness:0.90)
            settingTabItemsTextColorSameAsCategories        .value = true

            settingTabItemsRowOddOpacity                    .value = 0.00
            settingTabItemsRowEvenOpacity                   .value = 0.10

            settingTabItemsQuantityColorBackground          .value = UIColor(hue:0.4,saturation:1,brightness:0.1)
            settingTabItemsQuantityColorBackgroundOpacity   .value = 0.20
            settingTabItemsQuantityColorText                .value = UIColor(hue:0.00,saturation:0.00,brightness:1.00)
            settingTabItemsQuantityColorTextSameAsItems     .value = true
            settingTabItemsQuantityFont                     .value = settingTabItemsFont.value
            settingTabItemsQuantityFontGrowth               .value = 0.00
            settingTabItemsQuantityFontSameAsItems          .value = true
            
            settingTabThemesSolidColor                      .reset()
            settingTabThemesRangeFromColor                  .value = UIColor(white:0.40,alpha:0.73)
            settingTabThemesRangeToColor                    .value = UIColor(white:0.40,alpha:0.75)
            settingTabThemesName                            .value = "Range"
            settingTabThemesSaturation                      .value = 0.90
            
            synchronize()

        case "Honey":
            
            clear()
            
            themeCurrent                                    .value = name
            
            settingBackgroundColor                          .value = UIColor(white:0.08,alpha:1.00)
            
            settingAudioOn                                  .value = true
            settingSelectionColor                           .value = UIColor(hue:0.00,saturation:0.80,brightness:1.00)
            settingSelectionColorOpacity                    .value = 0.50
            
            settingTabSettingsHeaderTextColor               .value = UIColor.white
            settingTabSettingsFooterTextColor               .value = UIColor.white
            
            settingTabCategoriesUppercase                   .value = false
            settingTabCategoriesEmphasize                   .value = true
            settingTabCategoriesFont                        .value = "Noteworthy-Bold"
            settingTabCategoriesFontGrowth                  .value = 0
            settingTabCategoriesTextColor                   .value = UIColor(hue:0.06,saturation:1.00,brightness:1.00)
            
            settingTabItemsFont                             .value = settingTabCategoriesFont.value
            settingTabItemsFontGrowth                       .value = 0.0
            settingTabItemsUppercase                        .value = false
            settingTabItemsEmphasize                        .value = false
            settingTabItemsFontSameAsCategories             .value = true
            settingTabItemsTextColor                        .value = UIColor(hue:0.10,saturation:0.40,brightness:1.00)
            settingTabItemsTextColorSameAsCategories        .value = true
            
            settingTabItemsRowOddOpacity                    .value = 0.00
            settingTabItemsRowEvenOpacity                   .value = 0.20
            
            settingTabItemsQuantityColorBackground          .value = UIColor(hue:0.15,saturation:1.00,brightness:0.30)
            settingTabItemsQuantityColorBackgroundOpacity   .value = 0.10
            settingTabItemsQuantityColorText                .value = UIColor(hue:0.10,saturation:0.40,brightness:1.00)
            settingTabItemsQuantityColorTextSameAsItems     .value = true
            settingTabItemsQuantityFont                     .value = settingTabItemsFont.value
            settingTabItemsQuantityFontGrowth               .value = 0.00
            settingTabItemsQuantityFontSameAsItems          .value = true
            
            settingTabThemesSolidColor                      .reset()
            settingTabThemesRangeFromColor                  .value = UIColor(white:0.10,alpha:1.00)
            settingTabThemesRangeToColor                    .value = UIColor(white:0.13,alpha:1.00)
            settingTabThemesName                            .value = "Range"
            settingTabThemesSaturation                      .reset()
            
            synchronize()
            
        case "Pink":
            
            clear()
            
            themeCurrent                                    .value = name
            
            settingBackgroundColor                          .value = UIColor(hue:0.90,saturation:1.00,brightness:1.00)
            
            settingAudioOn                                  .value = true
            settingSelectionColor                           .value = UIColor(hue:0.51,saturation:0.20,brightness:1.00)
            settingSelectionColorOpacity                    .value = 0.30
            
            settingTabSettingsHeaderTextColor               .value = UIColor.white
            settingTabSettingsFooterTextColor               .value = UIColor.white
            
            settingTabCategoriesUppercase                   .value = false
            settingTabCategoriesEmphasize                   .value = true
            settingTabCategoriesFont                        .value = "SnellRoundhand-Black"
            settingTabCategoriesFontGrowth                  .value = 4
            settingTabCategoriesTextColor                   .value = UIColor(hue:0.85,saturation:0.30,brightness:1.00)
            
            settingTabItemsFont                             .value = settingTabCategoriesFont.value
            settingTabItemsFontGrowth                       .value = 4
            settingTabItemsUppercase                        .value = false
            settingTabItemsEmphasize                        .value = false
            settingTabItemsFontSameAsCategories             .value = true
            settingTabItemsTextColor                        .value = UIColor(hue:0.10,saturation:0.40,brightness:1.00)
            settingTabItemsTextColorSameAsCategories        .value = true
            
            settingTabItemsRowOddOpacity                    .value = 0.00
            settingTabItemsRowEvenOpacity                   .value = 0.20
            
            settingTabItemsQuantityColorBackground          .value = UIColor(hue:0.85,saturation:1.00,brightness:0.50)
            settingTabItemsQuantityColorBackgroundOpacity   .value = 0.50
            settingTabItemsQuantityColorText                .value = UIColor(hue:0.80,saturation:0.20,brightness:1.00)
            settingTabItemsQuantityColorTextSameAsItems     .value = true
            settingTabItemsQuantityFont                     .value = settingTabItemsFont.value
            settingTabItemsQuantityFontGrowth               .value = 5
            settingTabItemsQuantityFontSameAsItems          .value = true
            
            settingTabThemesSolidColor                      .reset()
            settingTabThemesRangeFromColor                  .value = UIColor(white:0.90,alpha:1.00)
            settingTabThemesRangeToColor                    .value = UIColor(white:0.93,alpha:1.00)
            settingTabThemesName                            .value = "Range"
            settingTabThemesSaturation                      .reset()
            
            synchronize()
            
        case "Sky":
            
            clear()
            
            themeCurrent                                    .value = name
            
            settingBackgroundColor                          .value = UIColor(hue:0.60,saturation:0.80,brightness:1.00)
            
            settingAudioOn                                  .value = true
            settingSelectionColor                           .value = UIColor(hue:0.06,saturation:1.00,brightness:1.00)
            settingSelectionColorOpacity                    .value = 1.00
            
            settingTabSettingsHeaderTextColor               .value = UIColor.white
            settingTabSettingsFooterTextColor               .value = UIColor.white
            
            settingTabCategoriesUppercase                   .value = false
            settingTabCategoriesEmphasize                   .value = false
            settingTabCategoriesFont                        .value = "GillSans-LightItalic"
            settingTabCategoriesFontGrowth                  .value = 5
            settingTabCategoriesTextColor                   .value = UIColor(hue:0.65,saturation:0.30,brightness:1.00)
            
            settingTabItemsFont                             .value = "GillSans-Italic"
            settingTabItemsFontGrowth                       .value = 4
            settingTabItemsUppercase                        .value = false
            settingTabItemsEmphasize                        .value = false
            settingTabItemsFontSameAsCategories             .value = true
            settingTabItemsTextColor                        .value = UIColor(hue:0.60,saturation:0.30,brightness:1.00)
            settingTabItemsTextColorSameAsCategories        .value = true
            
            settingTabItemsRowOddOpacity                    .value = 0.00
            settingTabItemsRowEvenOpacity                   .value = 0.20
            
            settingTabItemsQuantityColorBackground          .value = UIColor(hue:0.58,saturation:1.00,brightness:0.80)
            settingTabItemsQuantityColorBackgroundOpacity   .value = 0.70
            settingTabItemsQuantityColorText                .value = UIColor(hue:0.60,saturation:0.20,brightness:1.00)
            settingTabItemsQuantityColorTextSameAsItems     .value = true
            settingTabItemsQuantityFont                     .value = "GillSans-BoldItalic"
            settingTabItemsQuantityFontGrowth               .value = 4
            settingTabItemsQuantityFontSameAsItems          .value = true
            
            settingTabThemesSolidColor                      .reset()
            settingTabThemesRangeFromColor                  .value = UIColor(white:0.57,alpha:1.00)
            settingTabThemesRangeToColor                    .value = UIColor(white:0.60,alpha:1.00)
            settingTabThemesName                            .value = "Range"
            settingTabThemesSaturation                      .reset()
            
            synchronize()
            
        case "Charcoal":
            
            clear()
            
            themeCurrent                                    .value = name
            
            settingBackgroundColor                          .value = UIColor(hue:0.00,saturation:0.00,brightness:0.30)
            
            settingAudioOn                                  .value = true
            settingSelectionColor                           .value = UIColor(hue:0.00,saturation:1.00,brightness:1.00)
            settingSelectionColorOpacity                    .value = 1.00
            
            settingTabSettingsHeaderTextColor               .value = UIColor(white:0.60)
            settingTabSettingsFooterTextColor               .value = UIColor(white:0.60)
            
            settingTabCategoriesUppercase                   .value = false
            settingTabCategoriesEmphasize                   .value = false
            settingTabCategoriesFont                        .value = "GillSans"
            settingTabCategoriesFontGrowth                  .value = 1
            settingTabCategoriesTextColor                   .value = UIColor(hue:0.00,saturation:0.00,brightness:0.80)
            
            settingTabItemsFont                             .value = "GillSans-Italic"
            settingTabItemsFontGrowth                       .value = 1
            settingTabItemsUppercase                        .value = false
            settingTabItemsEmphasize                        .value = false
            settingTabItemsFontSameAsCategories             .value = true
            settingTabItemsTextColor                        .value = UIColor(hue:0.00,saturation:0.00,brightness:0.90)
            settingTabItemsTextColorSameAsCategories        .value = true
            
            settingTabItemsRowOddOpacity                    .value = 0.00
            settingTabItemsRowEvenOpacity                   .value = 0.40
            
            settingTabItemsQuantityColorBackground          .value = UIColor(hue:0.10,saturation:1.00,brightness:1.00)
            settingTabItemsQuantityColorBackgroundOpacity   .value = 1.00
            settingTabItemsQuantityColorText                .value = UIColor(hue:0.00,saturation:0.00,brightness:0.00)
            settingTabItemsQuantityColorTextSameAsItems     .value = false
            settingTabItemsQuantityFont                     .value = "GillSans"
            settingTabItemsQuantityFontGrowth               .value = 2
            settingTabItemsQuantityFontSameAsItems          .value = true
            
            settingTabThemesSolidColor                      .reset()
            settingTabThemesRangeFromColor                  .value = UIColor(white:0.57,alpha:1.00)
            settingTabThemesRangeToColor                    .value = UIColor(white:0.60,alpha:1.00)
            settingTabThemesName                            .value = "Range"
            settingTabThemesSaturation                      .value = 0.0
            
            synchronize()
            
        default:
            
            if let dictionary = themeCustomStorage.value[name] {
                print(dictionary)
                clear()
                themeCurrent.value = name
                decode(dictionary: dictionary, withPrefix:"setting") // only interested in 'setting' variables
                synchronize()
            }
            
            break
        }
    }
    
    func theme(saveWithCustomName name:String) -> Bool {
        
        if !themeArrayOfNamesPredefined.contains(name) {
            var dictionary = [String:Any]()
            encode(dictionary: &dictionary, withPrefix:"setting") // only interested in 'setting' variables
            print(dictionary)
            var current = themeCustomStorage.value
            current[name] = dictionary
            themeCustomStorage.value = current
            
            synchronize()
            
            return true
        }
        return false
    }
    
    func theme(removeCustomWithName name:String) -> Bool {
        
        if themeArrayOfNamesCustom.contains(name) {
            var current = themeCustomStorage.value
            current.removeValue(forKey: name)
            themeCustomStorage.value = current
            
            synchronize()
            
            return true
        }
        return false
    }

}
