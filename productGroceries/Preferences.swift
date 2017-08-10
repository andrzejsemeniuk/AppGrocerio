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
    var settingList                                     = GenericSetting<String>        (key:"settings-list", first:"Default,Apple,Princess,School,Draft,Plastik")
    var settingLastName                                 = GenericSetting<String>        (key:"settings-last-name", first:"Default")
    
    var SummaryList                                     = GenericSetting<String>        (key:"summary-list", first:"?")

}

