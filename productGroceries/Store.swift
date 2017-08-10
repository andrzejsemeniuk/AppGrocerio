//
//  Store.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import ASToolkit

class Store : NSObject
{
    struct Item
    {
        var name:       String
        var category:   String
        var quantity:   Int         = 0
        var note:       String      = ""
        
        static func create(name:String, category:String, quantity:Int = 0, note:String = "") -> Item {
            return Item(name:name,category:category,quantity:quantity,note:note)
        }
        
        mutating func reset()
        {
            quantity    = 0
            note        = ""
        }
        
        func isModified() -> Bool {
            return 0 < quantity
        }
        
        func serialize() -> [AnyObject] {
            return [quantity as AnyObject,note as AnyObject,name as AnyObject,category as AnyObject]
        }
        
        static func deserialize(_ name:String, category:String, from:[AnyObject]) -> Item {
            return Item(name:name,category:category,quantity:from[0] as! Int,note:from[1] as! String)
        }
        
        static func deserialize(_ from:[AnyObject]) -> Item {
            return Item(name:from[2] as! String,category:from[3] as! String,quantity:from[0] as! Int,note:from[1] as! String)
        }
    }
    
    
    
    class Manager : NSObject
    {
        enum Key: String {
            case Categories, Items
            
//            case SettingsBackgroundColor                        = "settings-background"
//            case SettingsAudioOn                                = "settings-audio-on"
//            case SettingsSelectionColor                         = "settings-selection-color"
//            case SettingsSelectionColorOpacity                  = "settings-selection-color-opacity"
//            
//            case SettingsTabSettingsHeaderTextColor             = "settings-header-text-color"
//            case SettingsTabSettingsFooterTextColor             = "settings-footer-text-color"
//
//            case SettingsTabCategoriesUppercase                 = "settings-categories-uppercase"
//            case SettingsTabCategoriesEmphasize                 = "settings-categories-emphasize"
//            case SettingsTabCategoriesFont                      = "settings-categories-font"
//            case SettingsTabCategoriesFontGrowth                = "settings-categories-font-growth"
//            case SettingsTabCategoriesTheme                     = "settings-categories-theme"
//            case SettingsTabCategoriesTextColor                 = "settings-categories-text-color"
//            case SettingsTabItemsFont                           = "settings-items-font"
//            case SettingsTabItemsFontGrowth                     = "settings-items-font-growth"
//            case SettingsTabItemsUppercase                      = "settings-items-uppercase"
//            case SettingsTabItemsEmphasize                      = "settings-items-emphasize"
//            case SettingsTabItemsFontSameAsCategories           = "settings-items-font-as-categories"
//            case SettingsTabItemsTextColor                      = "settings-items-text-color"
//            case SettingsTabItemsTextColorSameAsCategories      = "settings-items-text-color-as-categories"
//            case SettingsTabItemsRowOddOpacity                  = "settings-items-row-odd-alpha"
//            case SettingsTabItemsRowEvenOpacity                 = "settings-items-row-even-alpha"
//            case SettingsTabItemsQuantityColorBackground        = "settings-items-quantity-color-bg"
//            case SettingsTabItemsQuantityColorBackgroundOpacity = "settings-items-quantity-color-bg-opacity"
//            case SettingsTabItemsQuantityColorText              = "settings-items-quantity-color-text"
//            case SettingsTabItemsQuantityColorTextSameAsItems   = "settings-items-quantity-color-text-as-items"
//            case SettingsTabItemsQuantityFont                   = "settings-items-quantity-font"
//            case SettingsTabItemsQuantityFontGrowth             = "settings-items-quantity-font-growth"
//            case SettingsTabItemsQuantityFontSameAsItems        = "settings-items-quantity-font-as-items"
//            
//            case SettingsTabThemesSolidColor                    = "settings-themes-solid-color"
//            case SettingsTabThemesRangeFromColor                = "settings-themes-range-color-from"
//            case SettingsTabThemesRangeToColor                  = "settings-themes-range-color-to"
//            case SettingsTabThemesCustomColors                  = "settings-themes-custom-colors"
//            case SettingsTabThemesName                          = "settings-themes-name"
//            case SettingsTabThemesSaturation                    = "settings-themes-saturation"
            
            case SettingsCurrent                                = "settings:current"
            case SettingsList                                   = "settings-list"
            case SettingsLastName                               = "settings-last-name"
            
            case SummaryList                                    = "summary-list"
        }
        
        
        
        fileprivate class func itemsKey(_ category:String) -> String {
            return "category:"+category
        }
        
        
        
        
        class func itemPut              (_ item:Item,addQuantity:Bool = false)
        {
            // if item does not exit
            //  insert
            // else
            //  update
            
            var item = item
            
            if true
            {
                do {
                    let entityDescription   = NSEntityDescription.entity(forEntityName: "Item", in: AppDelegate.managedObjectContext)
                    
                    let set                 = { (newItem:NSManagedObject) in
                        newItem.setValue(item.name,         forKey:"name")
                        newItem.setValue(item.category,     forKey:"category")
                        newItem.setValue(item.quantity,     forKey:"quantity")
                        newItem.setValue(item.note,         forKey:"note")
                    }
                    
                    let create              = {
                        let newItem             = NSManagedObject(entity: entityDescription!, insertInto: AppDelegate.managedObjectContext)
                        set(newItem)
                        try newItem.managedObjectContext?.save()
                    }
                    
                    let update              = { (newItem:NSManagedObject) in
                        if addQuantity {
                            var quantity = newItem.value(forKey: "quantity") as? Int ?? 0
                            if quantity < 0 {
                                quantity = 0
                            }
                            if item.quantity < 0 {
                                item.quantity = 0
                            }
                            item.quantity += quantity
                        }
                        set(newItem)
                        try newItem.managedObjectContext?.save()
                    }
                    
                    let request             = NSFetchRequest<NSFetchRequestResult>()
                    
                    request.entity          = entityDescription
                    
                    request.predicate       = NSPredicate(format:"(name = %@) AND (category = %@)", item.name, item.category)
                    
                    do {
                        let result          = try AppDelegate.managedObjectContext.fetch(request)
                        
                        if 0 < result.count {
                            try update(result[0] as! NSManagedObject)
                        }
                        else {
                            try create()
                        }
                    } catch let error as NSError {
                        let fetchError      = error as NSError
                        print(fetchError)
                        try create()
                    }

                } catch let error as NSError {
                    print(error)
                }
            }
            else
            {
                let defaults = UserDefaults.standard
                
                let key = itemsKey(item.category)
                
                var all = defaults.dictionary(forKey: key)
                
                if all == nil {
                    all = [String:AnyObject]()
                }
                
                all![item.name] = item.serialize()
                
                defaults.set(all!,forKey:key)
            }
        }
        
        class func itemReset           (_ item:Item)
        {
            // if item exists
            //  reset it
            
            if true {
                itemPut(Item(name:item.name,category:item.category,quantity:0,note:""))
            }
            else {
                let defaults = UserDefaults.standard
                
                let key = itemsKey(item.category)
                
                if var all = defaults.dictionary(forKey: key) {
                    all.removeValue(forKey: item.name)
                    var item1 = item
                    item1.reset()
                    all[item.name] = item1.serialize()
                    defaults.set(all,forKey:key)
                }
            }
        }
        
        class func itemRemove           (_ item:Item)
        {
            // if item exists
            //  remove it
            
            if true {
                let entityDescription   = NSEntityDescription.entity(forEntityName: "Item", in: AppDelegate.managedObjectContext)
                let oldItem             = NSManagedObject(entity: entityDescription!, insertInto: AppDelegate.managedObjectContext)
                
                oldItem.setValue(item.name,         forKey:"name")
                oldItem.setValue(item.category,     forKey:"category")
//                oldItem.setValue(item.quantity,     forKey:"quantity")
//                oldItem.setValue(item.note,         forKey:"note")

                AppDelegate.managedObjectContext.delete(oldItem)
            }
            else {
                let key = itemsKey(item.category)
                
                let defaults = UserDefaults.standard
                
                if var all = defaults.dictionary(forKey: key) {
                    all.removeValue(forKey: item.name)
                    defaults.set(all,forKey:key)
                }
            }
        }
        
        class func itemRemoveAll            ()
        {
            let fetchRequest        = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
            let deleteRequest       = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try AppDelegate.persistentStoreCoordinator.execute(deleteRequest, with: AppDelegate.managedObjectContext)
            } catch let error as NSError {
                print(error)
            }
        }
        
        class func itemGetAllInCategory   (_ category:String, sorted:Bool = true) -> [Item]
        {
            // return all items in category
            
            var results:[Item] = []
            
            if true {
                let request             = NSFetchRequest<NSFetchRequestResult>()
                
                let entityDescription   = NSEntityDescription.entity(forEntityName: "Item", in: AppDelegate.managedObjectContext)
                
                request.entity          = entityDescription

                request.predicate       = NSPredicate(format:"%K = %@", "category", category)
                
                do {
                    let result          = try AppDelegate.managedObjectContext.fetch(request)
//                    print(result)
                    
                    var anItem:Item = Item(name:"",category:"",quantity:0,note:"")
                    
                    for object in result {
//                        print("object=\(object)")
                        let object = object as AnyObject
                        
                        anItem.name     = object.value(forKey:"name") as! String
                        anItem.category = object.value(forKey:"category") as! String
                        anItem.quantity = object.value(forKey:"quantity") as! Int
                        anItem.note     = object.value(forKey:"note") as! String
                        
                        results.append(anItem)
                    }
                    
                } catch {
                    let fetchError      = error as NSError
                    print(fetchError)
                }
            }
            else {
                let defaults = UserDefaults.standard
                
                if let all = defaults.dictionary(forKey: itemsKey(category)) {
                    for (key,value) in all {
                        if let array = value as? Array<AnyObject> {
                            results.append(Item.deserialize(key, category:category, from:array))
                        }
                    }
                }
            }
            
            return sorted ? results.sorted { $0.name < $1.name } : results
        }
        
        
        
        
        class func categoryAdd          (_ newCategory:String) -> Bool
        {
            var result = false
            
            let category = newCategory.trimmed()
            
            if !category.empty {
                var categories = categoryGetAll()
                if !categories.contains(category) {
                    categories.append(category)
                    let defaults = UserDefaults.standard
                    defaults.set(categories, forKey:Key.Categories.rawValue)
                    result = true
                }
            }
            
            return result
        }
        
        class func categoryReset        (_ category:String)
        {
            for item in itemGetAllInCategory(category,sorted:false) {
                itemReset(item)
            }
        }
        
        class func categoryRemove       (_ oldCategory:String) -> Bool
        {
            var result = false
            
            let category = oldCategory.trimmed()
            
            if !category.empty {
                let categories0 = categoryGetAll()
                let categories1 = categories0.filter({ $0 != category })
                
                if categories1.count < categories0.count {
                    let defaults = UserDefaults.standard
                    defaults.set(categories1, forKey:Key.Categories.rawValue)
                    defaults.removeObject(forKey: itemsKey(category))
                    result = true
                }
            }
            
            return result
        }
        
        class func categoryClearAll      ()
        {
            for category in categoryGetAll() {
                _ = categoryRemove(category)
            }
        }
        
        class func categoryGetAll        () -> [String]
        {
            let defaults = UserDefaults.standard
            
            var result = [String]()
            
            if let categories = defaults.array(forKey: Key.Categories.rawValue) {
                for category in categories {
                    result.append(category as! String)
                }
            }
            
            return result.sorted { return $0 < $1 }
        }
        
        class func summary              () -> [[Item]]
        {
            var result = [[Item]]()
            
            for category in categoryGetAll() {
                var add = [Item]()
                for item in itemGetAllInCategory(category,sorted:true) {
                    if 0 != item.quantity {
                        add.append(item)
                    }
                }
                if 0 < add.count {
                    result.append(add)
                }
            }
            
            return result
        }
        
        
        
        
        class func settingsGetCurrent() -> [String:AnyObject]
        {
            if let defaults = UserDefaults.standard.dictionary(forKey: Key.SettingsCurrent.rawValue) {
                return defaults as [String : AnyObject]
            }
            
            let defaults = [String:AnyObject]()
            
            UserDefaults.standard.set(defaults,forKey:Key.SettingsCurrent.rawValue)
            
            return defaults
        }
        
        
        
        
        class func settingsGetBoolForKey(_ key:Key, defaultValue:Bool = false) -> Bool
        {
            if let result = settingsGetCurrent()["b:"+key.rawValue] as? Bool {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetBool(_ value:Bool, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["b:"+forKey.rawValue] = value as AnyObject
            
            UserDefaults.standard.set(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsGetCGFloatForKey(_ key:Key, defaultValue:Float = 0) -> CGFloat
        {
            if let result = settingsGetCurrent()["f:"+key.rawValue] as? Float {
                return CGFloat(result)
            }
            return CGFloat(defaultValue)
        }
        
        class func settingsGetFloatForKey(_ key:Key, defaultValue:Float = 0) -> Float
        {
            if let result = settingsGetCurrent()["f:"+key.rawValue] as? Float {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetFloat(_ value:Float, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["f:"+forKey.rawValue] = value as AnyObject
            
            UserDefaults.standard.set(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsGetStringForKey(_ key:Key, defaultValue:String = "") -> String
        {
            if let result = settingsGetCurrent()["s:"+key.rawValue] as? String {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetString(_ value:String, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["s:"+forKey.rawValue] = value as AnyObject
            
            UserDefaults.standard.set(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsPackColor(_ value:UIColor) -> [Float]
        {
            let rgba = value.RGBA
            
            let RGBA:[Float] = [
                Float(rgba.red),
                Float(rgba.green),
                Float(rgba.blue),
                Float(rgba.alpha)
            ]
            
            return RGBA
        }
        
        class func settingsUnpackColor(_ value:[Float], defaultValue:UIColor) -> UIColor
        {
            if 3 < value.count
            {
                return UIColor.RGBA(value[0],value[1],value[2],value[3])
            }
            else
            {
                return defaultValue
            }
        }
        
        class func settingsGetColorForKey(_ key:Key, defaultValue:UIColor = UIColor.black) -> UIColor
        {
            if let result = settingsGetCurrent()["c:"+key.rawValue] as? [Float] {
                return settingsUnpackColor(result,defaultValue:defaultValue)
            }
            return defaultValue
        }
        
        class func settingsSetColor(_ value:UIColor, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["c:"+forKey.rawValue] = settingsPackColor(value) as AnyObject
            
            UserDefaults.standard.set(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsGetArrayForKey(_ key:Key, defaultValue:[AnyObject] = []) -> [AnyObject]
        {
            if let result = settingsGetCurrent()["A:"+key.rawValue] as? [AnyObject] {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetArray(_ value:[AnyObject], forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["A:"+forKey.rawValue] = value as AnyObject
            
            UserDefaults.standard.set(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        
        class func settingsGetDictionaryForKey(_ key:Key, defaultValue:[String:AnyObject] = [:]) -> [String:AnyObject]
        {
            if let result = settingsGetCurrent()["D:"+key.rawValue] as? [String:AnyObject] {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetDictionary(_ value:[String:AnyObject], forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["D:"+forKey.rawValue] = value as AnyObject
            
            UserDefaults.standard.set(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        
        
        
        
//        class func settingsGetCategoriesFont(_ defaultValue:UIFont? = nil) -> UIFont
//        {
//            var defaultValue = defaultValue
//            
//            if defaultValue == nil {
//                defaultValue = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
//            }
//            
//            if let result = UIFont(name:settingsGetStringForKey(
        // .SettingsTabCategoriesFont,defaultValue:defaultValue!.familyName),
//                                   size:defaultValue!.pointSize + settingsGetCGFloatForKey(.SettingsTabCategoriesFontGrowth))
//            {
//                return result
//            }
//            
//            return defaultValue!
//        }
        
//        class func settingsGetItemsFont(_ defaultValue:UIFont? = nil) -> UIFont
//        {
//            if settingsGetBoolForKey(.SettingsTabItemsFontSameAsCategories) {
//                return settingsGetCategoriesFont()
//            }
//            
//            var defaultValue = defaultValue
//            
//            if defaultValue == nil {
//                defaultValue = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
//            }
//            
//            if let result = UIFont(name:settingsGetStringForKey(.SettingsTabItemsFont,defaultValue:defaultValue!.familyName),
//                                   size:defaultValue!.pointSize + settingsGetCGFloatForKey(.SettingsTabItemsFontGrowth))
//            {
//                return result
//            }
//            
//            return defaultValue!
//        }
        
//        class func settingsGetItemsQuantityFont(_ defaultValue:UIFont? = nil) -> UIFont
//        {
//            if settingsGetBoolForKey(.SettingsTabItemsQuantityFontSameAsItems) {
//                return settingsGetItemsFont()
//            }
//            
//            var defaultValue = defaultValue
//            
//            if defaultValue == nil {
//                defaultValue = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
//            }
//            
//            if let result = UIFont(name:settingsGetStringForKey(.SettingsTabItemsQuantityFont,defaultValue:defaultValue!.familyName),
//                                   size:defaultValue!.pointSize + settingsGetCGFloatForKey(.SettingsTabItemsQuantityFontGrowth))
//            {
//                return result
//            }
//            
//            return defaultValue!
//        }
        
        
        
        
        
//        class func settingsGetBackgroundColor(_ defaultValue:UIColor = UIColor(hue:0.9)) -> UIColor
//        {
//            return settingsGetColorForKey(.SettingsBackgroundColor,defaultValue:defaultValue)
//        }
        
        class func settingsGetSelectionColor(_ defaultValue:UIColor = UIColor(white:1,alpha:0.2)) -> UIColor
        {
            return defaultValue
//            let hsba    = settingsGetColorForKey(.SettingsSelectionColor,defaultValue:defaultValue).HSBA()
//            
//            let opacity = settingsGetFloatForKey(.SettingsSelectionColorOpacity,defaultValue:Float(defaultValue.alpha))
//            
//            return UIColor(hue:hsba.hue,saturation:hsba.saturation,brightness:hsba.brightness,alpha:CGFloat(opacity))
        }
        

        
//        class func settingsGetCategoriesTextColor(_ defaultValue:UIColor = UIColor(hue:0.87)) -> UIColor
//        {
//            return settingsGetColorForKey(.SettingsTabCategoriesTextColor,defaultValue:defaultValue)
//        }
        
//        class func settingsGetItemsTextColor(_ defaultValue:UIColor = UIColor(hue:0.95)) -> UIColor
//        {
//            if settingsGetBoolForKey(.SettingsTabItemsTextColorSameAsCategories) {
//                return settingsGetCategoriesTextColor()
//            }
//            
//            return settingsGetColorForKey(.SettingsTabItemsTextColor,defaultValue:defaultValue)
//        }
        
//        class func settingsGetItemsQuantityBackgroundColorWithOpacity(_ opacityOn:Bool) -> UIColor
//        {
//            let color0  = UIColor.red
//            
//            let color1  = settingsGetColorForKey(.SettingsTabItemsQuantityColorBackground,defaultValue:color0)
//            
//            let alpha   = opacityOn ? settingsGetFloatForKey(.SettingsTabItemsQuantityColorBackgroundOpacity,defaultValue:0.8) : 0.8
//            
//            return color1.withAlphaComponent(CGFloat(alpha))
//        }
//        
//        class func settingsGetItemsQuantityTextColor(_ defaultValue:UIColor = UIColor.white) -> UIColor
//        {
//            if settingsGetBoolForKey(.SettingsTabItemsQuantityColorTextSameAsItems) {
//                return settingsGetItemsTextColor()
//            }
//            
//            return settingsGetColorForKey(.SettingsTabItemsQuantityColorText,defaultValue:defaultValue)
//        }
//        
//        
//        
//        
//        
//        
//        
//        class func settingsSetThemeWithName(_ name:String)
//        {
//            settingsSetString(name,forKey:Key.SettingsTabThemesName)
//        }
//        
//        
//        
//        
//        
//        
//        
//        class func settingsGetThemeName(_ defaultValue:String = "Plain") -> String
//        {
//            return settingsGetStringForKey(Key.SettingsTabThemesName,defaultValue:defaultValue)
//        }
        
        
        
        
        
        
        
//        class func settingsGetThemesSolidColor(_ defaultValue:UIColor = UIColor.red) -> UIColor
//        {
//            return settingsGetColorForKey(.SettingsTabThemesSolidColor,defaultValue:defaultValue)
//        }
        
//        class func settingsGetThemesRangeFromColor(_ defaultValue:UIColor = UIColor.yellow) -> UIColor
//        {
//            return settingsGetColorForKey(.SettingsTabThemesRangeFromColor,defaultValue:defaultValue)
            //        let dictionary = settingsGetDictionaryForKey(.SettingsTabThemesRangeColors)
            //
            //        if let color = dictionary["from"] as? [Float] {
            //            return settingsUnpackColor(color,defaultValue:defaultValue)
            //        }
            //
            //        return defaultValue
//        }
//        
//        class func settingsGetThemesRangeToColor(_ defaultValue:UIColor = UIColor.orange) -> UIColor
//        {
//            return settingsGetColorForKey(.SettingsTabThemesRangeToColor,defaultValue:defaultValue)
//            //        let dictionary = settingsGetDictionaryForKey(.SettingsTabThemesRangeColors)
//            //
//            //        if let color = dictionary["to"] as? [Float] {
//            //            return settingsUnpackColor(color,defaultValue:defaultValue)
//            //        }
//            //
//            //        return defaultValue
//        }
//        
//        
//        
//        class func settingsSetThemesSolidColor(_ color:UIColor)
//        {
//            settingsSetColor(color,forKey:.SettingsTabThemesSolidColor)
//        }
        
//        class func settingsSetThemesRangeFromColor(_ color:UIColor)
//        {
//            settingsSetColor(color,forKey:.SettingsTabThemesRangeFromColor)
//            //        var dictionary = settingsGetDictionaryForKey(.SettingsTabThemesRangeColors)
//            //        dictionary["from"] = settingsPackColor(color)
//            //        settingsSetDictionary(dictionary,forKey:.SettingsTabThemesRangeColors)
//        }
//        
//        class func settingsSetThemesRangeToColor(_ color:UIColor)
//        {
//            settingsSetColor(color,forKey:.SettingsTabThemesRangeToColor)
//            //        var dictionary = settingsGetDictionaryForKey(.SettingsTabThemesRangeColors)
//            //        dictionary["to"] = settingsPackColor(color)
//            //        settingsSetDictionary(dictionary,forKey:.SettingsTabThemesRangeColors)
//        }
        
        
        
        
        
        
        class func displayHelpPageForCategories(_ controller:ControllerOfCategories)
        {
            let key = "display-help-categories"
            
            let defaults = UserDefaults.standard
            
            if false && !defaults.bool(forKey: key) {
                defaults.set(true,forKey:key)
                
                let alert = UIAlertController(title:"Categories", message:"Welcome!  Add new categories by tapping on the plus button "
                    + "in the top right corner.  Remove categories by swiping from right to left.", preferredStyle:.alert)
                
                let actionOK = UIAlertAction(title:"OK", style:.cancel, handler: {
                    action in
                })
                
                alert.addAction(actionOK)
                
                controller.present(alert, animated:true, completion: {
                    print("completed showing add alert")
                })
            }
        }
        
        
        class func displayHelpPageForItems(_ controller:ItemsController)
        {
            let key = "display-help-items"
            
            let defaults = UserDefaults.standard
            
            if !defaults.bool(forKey: key) {
                defaults.set(true,forKey:key)
                
                let alert = UIAlertController(title:"Items", message:"Tap on the right side of an item to add quantity.  Tap on the left side to subtract quantity.", preferredStyle:.alert)
                
                let actionOK = UIAlertAction(title:"OK", style:.cancel, handler: {
                    action in
                })
                
                alert.addAction(actionOK)
                
                controller.present(alert, animated:true, completion: {
                    print("completed showing add alert")
                })
                
            }
        }
        
        
        class func displayHelpPageForSummary(_ controller:ControllerOfSummary)
        {
            let key = "display-help-summary"
            
            let defaults = UserDefaults.standard
            
            if false && !defaults.bool(forKey: key) {
                defaults.set(true,forKey:key)
                
                let alert = UIAlertController(title:"Summary", message:"This page presents a list of items you selected in categories.  Remove an item by swiping from right to left.", preferredStyle:.alert)
                
                let actionOK = UIAlertAction(title:"OK", style:.cancel, handler: {
                    action in
                })
                
                alert.addAction(actionOK)
                
                controller.present(alert, animated:true, completion: {
                    print("completed showing add alert")
                })
                
            }
        }
        
        class func clearHelpFlags()
        {
            let defaults = UserDefaults.standard
            
            defaults.removeObject(forKey: "display-help-categories")
            defaults.removeObject(forKey: "display-help-items")
            defaults.removeObject(forKey: "display-help-summary")
        }
        
        class func migrateItemsIfRequired()
        {
            let request             = NSFetchRequest<NSFetchRequestResult>()
            
            request.entity          = NSEntityDescription.entity(forEntityName: "Item", in: AppDelegate.managedObjectContext)
            
            do {
                let result          = try AppDelegate.managedObjectContext.fetch(request)
                
                if result.count == 0 {
                    createCategories()
                }
            }
            catch {
                print(error)
            }
        }
        
        class func resetIfRequired()
        {
            let categories = categoryGetAll()
            
            if categories.count < 1 {
                reset()
            }
            else {
                migrateItemsIfRequired()
            }
            
            resetSettings()
        }
        
        class func resetSettings()
        {
            // DEFAULT
            
            
            
            let settings0 = settingsGetLastName()
            
            
            if 0 < settings0.length {
                _ = settingsUse(settings0)
            }
        }
        
        class func reset()
        {
            let categories = categoryGetAll()
            
            // empty,0 => yes
            // empty,n => no
            // not empty,0 => yes
            // not empty,n => yes
            
            
            
            for category in categories {
                _ = categoryRemove(category)
            }
            
            createCategories()
            
//            settingsSetBool(true,forKey:.SettingsTabCategoriesEmphasize)
            //        settingsSetBool(true,forKey:.SettingsTabCategoriesUppercase)
        }
        
        class func synchronize()
        {
            let defaults = UserDefaults.standard
            
            defaults.synchronize()
        }
        
        
        
        
        
        class func settingsGetLastName(_ defaultValue:String = "") -> String
        {
            let defaults = UserDefaults.standard
            
            if let result = defaults.string(forKey: Key.SettingsLastName.rawValue) {
                return result
            }
            
            return defaultValue
        }
        
        fileprivate class func settingsKeyForName(_ name:String) -> String {
            return "settings="+name
        }
        
        
        class func settingsExist    (_ name:String) -> Bool
        {
            var name = name
            var result = false
            
            name = name.trimmed()
            
            if 0 < name.length
            {
                let defaults = UserDefaults.standard
                
                if defaults.dictionary(forKey: settingsKeyForName(name)) != nil
                {
                    result = true
                }
            }
            
            return result
        }
        
        class func settingsUse  (_ name:String) -> Bool
        {
            var name = name
            var result = false
            
            name = name.trimmed()
            
            if 0 < name.length
            {
                let defaults = UserDefaults.standard
                
                if let settings = defaults.dictionary(forKey: settingsKeyForName(name))
                {
                    defaults.set(settings,forKey:Key.SettingsCurrent.rawValue)
                    
                    defaults.set(name,forKey:Key.SettingsLastName.rawValue)
                    
                    result = true
                }
            }
            
            return result
        }
        
        class func settingsRemove    (_ name:String) -> Bool
        {
            var name = name
            var result = false
            
            name = name.trimmed()
            
            if 0 < name.length
            {
                let defaults = UserDefaults.standard
                
                defaults.removeObject(forKey: settingsKeyForName(name))
                
                do
                {
                    var list = Set<String>(settingsList())
                    
                    list.remove(name)
                    
                    let array = Array(list)
                    
                    defaults.set(array,forKey:Key.SettingsList.rawValue)
                }
                
                result = true
            }
            
            return result
        }
        
        class func settingsSave (_ name:String) -> Bool
        {
            var name = name
            var result = false
            
            name = name.trimmed()
            
            if 0 < name.length
            {
                let defaults = UserDefaults.standard
                
                if let settings = defaults.dictionary(forKey: Key.SettingsCurrent.rawValue)
                {
                    defaults.set(settings,forKey:settingsKeyForName(name))
                    
                    defaults.set(name,forKey:Key.SettingsLastName.rawValue)
                    
                    do
                    {
                        var list = Set<String>(settingsList())
                        
                        list.insert(name)
                        
                        let array = Array(list)
                        
                        defaults.set(array,forKey:Key.SettingsList.rawValue)
                    }
                    
                    result = true
                }
            }
            
            return result
        }
        
        class func settingsListIsEmpty() -> Bool
        {
            let defaults = UserDefaults.standard
            
            let array = defaults.array(forKey: Key.SettingsList.rawValue)
            
            return array == nil || 0 == array!.count
        }
        
        class func settingsList     () -> [String]
        {
            var result:[String] = []
            
            let defaults = UserDefaults.standard
            
            if let array = defaults.array(forKey: Key.SettingsList.rawValue) {
                
                for element in array {
                    
                    result.append(element as! String)
                    
                }
            }
            
            return result
        }
        
        
        
        
        
        fileprivate class func summaryKeyForName(_ name:String) -> String {
            return "summary="+name
        }
        
        class func summaryClear     ()
        {
            for outer in summary() {
                for item in outer {
                    itemReset(item)
                }
            }
        }
        
        class func summaryGet       () -> [Item]
        {
            var array = [Item]()
            
            for outer in summary() {
                for item in outer {
                    array.append(item)
                }
            }
            
            return array
        }
        
        class func summaryAdd       (_ name:String) -> Bool
        {
            var result = false
            
            let defaults = UserDefaults.standard
            
            if let summary = defaults.array(forKey: summaryKeyForName(name)) {
                
                for element in summary {
                    
                    if let array = element as? [AnyObject] {
                        
                        let item = Item.deserialize(array)
                        
                        itemPut(item,addQuantity:true)
                    }
                }
                result = true
            }
            
            return result
        }
        
        class func summaryUse       (_ name:String) -> Bool
        {
            var result = false
            
            let defaults = UserDefaults.standard
            
            if let summary = defaults.array(forKey: summaryKeyForName(name)) {
                
                summaryClear()
                
                for element in summary {
                    
                    if let array = element as? [AnyObject] {
                        
                        let item = Item.deserialize(array)
                        
                        itemPut(item)
                    }
                }
                result = true
            }
            
            return result
        }
        
        class func summarySave      (_ name:String) -> Bool
        {
            var result = false
            
            if 0 < name.length
            {
                let defaults = UserDefaults.standard
                
                var items = [AnyObject]()
                
                for item in summaryGet() {
                    items.append(item.serialize() as AnyObject)
                }
                
                defaults.set(items,forKey:summaryKeyForName(name))
                
                do
                {
                    var list = Set<String>(summaryList())
                    
                    list.insert(name)
                    
                    let array = Array(list)
                    
                    defaults.set(array,forKey:Key.SummaryList.rawValue)
                }
                
                result = true
            }
            
            return result
        }
        
        class func summaryList      () -> [String]
        {
            var result:[String] = []
            
            let defaults = UserDefaults.standard
            
            if let array = defaults.array(forKey: Key.SummaryList.rawValue) {
                
                for element in array {
                    
                    result.append(element as! String)
                }
            }
            
            return result.sorted()
        }
        
        
        
        
        
        class func createCategories ()
        {
            let createCategory = { (name:String, items:[String]) in
                let category = name.trimmed()
                if 0 < category.length {
                    _ = categoryAdd(category)
                    for item in items {
                        itemPut(Item.create(name:item.trimmed(),category:category))
                    }
                }
            }
            
            createCategory("Baby",[
                "Food",
                "Formula",
                "Lotion",
                "Wash",
                "Wipes",
                "Diapers",
                ])
            createCategory("Bakery",[
                "Croissants",
                "Croissants, Plain",
                "Croissants, Butter",
                "Croissants, Chocolate",
                "Croissants, Almond",
                "Bread",
                "Bread, Wholegrain",
                "Bread, Rye",
                "Bread, French",
                "Bread, Sourdough",
                "Break, Pita",
                "Muffins",
                "Muffins, Blueberry",
                "Muffins, Chocolate",
                "Buns, Hot Dog",
                "Buns, Plain",
                "Buns, Cheese",
                "Rolls",
                "Baguette",
                "Baguette, French",
                "Bagels",
                "Cake",
                "Cake, Birthday",
                "Cake, Anniversary",
                
                "Pie",
                
                "Donuts",
                "Donuts, Glazed",
                "Donuts, Cream Cheese",
                "Donuts, Rasberry",
                "Donuts, Chocolate",
                ])
            createCategory("Baking",[
                "Baking Powder",
                "Bread Crumbs",
                "Mix",
                "Mix, Cake",
                "Mix, Brownie",
                "Cake, Icing",
                "Cocoa",
                "Chocolate",
                "Chocolate, Chips",
                "Chocolate, Semi-Sweet",
                "Shortening",
                "Honey",
                "Oil",
                "Oil, Canola",
                "Oil, Coconut",
                "Oil, Olive",
                "Oil, Safflower",
                "Vinegar",
                "Sugar",
                "Salt",
                ])
            createCategory("Beverages",[
                "Coffee",
                "Coffee, Whole Bean",
                "Coffee, Whole Bean, Dark Roast",
                "Coffee, Whole Bean, Light Roast",
                "Coffee, Whole Bean, French Roast",
                "Coffee, Ground",
                "Coffee, Ground, Dark Roast",
                "Coffee, Ground, Light Roast",
                "Coffee, Ground, French Roast",
                "Tea","Tea, Herbal","Tea, Green",
                "Fruit Punch",
                "Ginger Ale",
                "Juice, Apple",
                "Juice, Papaya",
                "Juice, Cranberry",
                "Juice, Tropical",
                "Juice, Orange",
                "Juice, Lemon",
                "Soda",
                "Water","Water, Mineral","Water, Coconut"
                ])
            createCategory("Beverages / Alcohol",[
                "Beer",
                "Wine, Cabernet Sauvignon",
                "Wine, Chardonnay",
                "Wine, Merlot",
                "Wine, Malbec"
                ])
            createCategory("Candy + Snacks",[
                "Chips, Potato",
                "Chips, Corn",
                "Salsa",
                "Dip",
                "Chocolate, Dark",
                "Chocolate, White",
                "Chocolate, Milk",
                "Candy",
                "Cookies",
                
                "Crackers",
                "Dried Fruit",
                "Nuts",
                "Popcorn",
                "Pretzels"
                ])
            createCategory("Canned",[
                "Asparagus",
                "Beans, Pinto",
                "Beans, Navy",
                "Beans, Black",
                "Beans, Kidney",
                "Beans, Cannellini",
                "Beans, White",
                "Chick Peas",
                "Chili",
                "Corn",
                "Olives, Green",
                "Olives, Black",
                "Tomatoes",
                "Tomatoes, Crushed",
                "Tomatoes, Diced",
                "Tomato Sauce",
                "Peas, Green",
                ])
            createCategory("Dairy",[
                "Cheese",
                "Cheese, Bleu",
                "Cheese, Feta",
                "Cheese, Goat",
                "Cheese, Cottage",
                "Cheese, Slices",
                "Cheese, Colby",
                "Cheese, Mozzarella",
                "Cheese, Munster",
                "Cheese, Jack Pepper",
                "Cheese, Cheddar",
                "Cheese, Camembert",
                "Cheese, Provolone",
                "Cheese, Ricotta",
                "Cheese, Swiss",
                "Cheese, Emmental",
                "Milk",
                "Milk, 2%", "Milk, Whole", "Milk, 1%", "Milk, Chocolate",
                "Eggs",
                "Butter",
                "Half & Half",
                "Cream",
                "Cream, Whipped",
                "Cream, Sour",
                "Yogurt",
                "Yogurt, Fat Free", "Yogurt, Reducted Fat", "Yogurt, Whole", "Yogurt, Vanilla"
                ])
            createCategory("Frozen",[
                "Ice Cream",
                "Ice Cream, Vanilla",
                "Ice Cream, Strawberry",
                "Ice Cream, Butter Pecan",
                "Ice Cream, Almong Chocolate",
                "Ice Cream, Chocolate",
                "Yogurt",
                "Peas, Green",
                "Carrots",
                "Peaches",
                "Pizza",
                "Pizza, Small",
                "Pizza, Large",
                "TV Dinner",
                "Blueberries",
                "Rasberries",
                "Strawberries",
                ])
            createCategory("Meat",[
                "Bacon",
                "Beef",
                "Beef, Angus","Beef, Sausage",
                "Chicken", "Chicken, Thighs", "Chicken, Wings", "Chicken, Legs",
                "Pork", "Pork, Minced", "Pork, Chops", "Pork, Sausage",
                "Turkey",
                "Hot Dogs",
                ])
            createCategory("Meat / Canned",[
                "Beef",
                "Beef, Angus",
                "Chicken", "Chicken, Thighs", "Chicken, Wings", "Chicken, Legs",
                "Pork", "Pork, Minced", "Pork, Chops",
                ])
            createCategory("Non-Food",[
                "Foil, Aluminum",
                "Wrap, Plastic",
                
                "Paper, Toilet",
                "Paper, Napkins",
                "Paper, Towels",
                "Paper, Wax",
                
                "Matches",
                "Lightbulb",
                "Garbage Bags",
                
                "Laundry, Detergent",
                "Laundry, Fabric Softener"
                ])
            createCategory("Other",[
                "Rice",
                "Rice, White",
                "Rice, Brown",
                "Cereal",
                "Pasta",
                "Pasta, Spaghetti",
                "Pasta, Fettucine",
                "Pasta, Vermicelli",
                ])
            createCategory("Personal",[
                "Deodorant",
                "Soap, Bath",
                "Soap, Hand",
                "Soap, Sanitizing",
                "Wipes, Sanitizing",
                "Cosmetics, Lipstick",
                "Cotton, Swabs",
                "Cotton, Balls",
                "Cleanser, Facial",
                "Tissue, Facial",
                "Lip Balm",
                "Lotion, Moisturizing",
                "Mouthwash",
                "Toothpaste",
                "Toothbrush",
                "Floss",
                "Hair, Shampoo",
                "Hair, Conditioner",
                "Shaver",
                "Shaving Cream",
                ])
            createCategory("Pet",[
                "Food",
                "Litter",
                "Treatment",
                "Shampoo",
                ])
            createCategory("Produce / Fruit",[
                "Apples",
                "Apples, Granny Smith",
                "Apples, McIntosh",
                "Apples, Gala",
                "Apples, Fuji",
                "Apples, Braeburn",
                "Coconut",
                "Lemons",
                "Oranges",
                "Pears",
                "Pears, Anjou",
                "Pears, Bartlett",
                "Peaches",
                "Bananas",
                "Blueberries",
                "Cranberries",
                "Cherries",
                "Grapefruit", "Grapefruit, Pink",
                "Grapes","Grapes, White", "Grapes, Red",
                "Melon",
                "Nectarines",
                "Plums",
                "Rasberries",
                "Strawberries",
                "Watermelon",
                ])
            createCategory("Produce / Herbs",[
                "Garlic",
                "Ginger Root",
                "Cilantro",
                "Parsley","Parsley, Italian",
                "Turmeric",
                "Turnip",
                "Rutabaga",
                "Ginseng Root",
                ])
            createCategory("Produce / Vegetables",[
                "Asparagus",
                "Avocado",
                "Beets",
                "Broccoli",
                "Cabbage",
                "Carrots",
                "Celery",
                "Cilantro",
                "Cauliflower",
                "Cucumber",
                "Cucumber, English",
                "Fennel",
                "Garlic","Ginger",
                "Lettuce", "Lettuce, Iceberg", "Lettuce, Romaine",
                "Onions", "Onions, Yellow", "Onions, White",
                "Mushrooms",
                "Peppers",
                "Peppers, Green",
                "Peppers, Red",
                "Peppers, Orange",
                "Peppers, Yellow",
                "Potatoes", "Potatoes, Russett", "Potatoes, Golden",
                "Radishes, Red", "Radish, Daikon",
                "Spinach",
                "Squash",
                "Tomatoes", "Tomatoes, Roma", "Tomatoes, Vine",
                "Zucchini",
                ])
            createCategory("Seafood",[
                "Tuna",
                "Salmon", "Salmon, Pink", "Salmon, Red Sockeye",
                "Crab",
                "Lobster",
                "Mussels",
                "Oysters",
                "Shrimp",
                "Tilapia",
                "Cod",
                "Calamari",
                ])
            createCategory("Seafood / Canned",[
                "Tuna",
                "Salmon", "Salmon, Pink", "Salmon, Red Sockeye"
                ])
            createCategory("Spreads + Condiments",[
                "Ketchup",
                "Mayonnaise",
                "Relish",
                "Sauce, BBQ",
                "Sauce, Pasta",
                "Sauce, Soy",
                "Sauce, Steak",
                "Sauce, Hot",
                "Mustard",
                "Mustard, Dijon",
                "Mustard, Yellow",
                "Salad Dressing",
                "Salad Dressing, Italian",
                "Salad Dressing, Ranch",
                "Salad Dressing, Thousand Island",
                
                "Butter",
                "Sour Cream",
                "Hummus",
                "Hummus, Olive",
                "Peanut Butter",
                "Peanut Butter, Crunchy",
                "Almond Butter",
                "Almond Butter, Crunchy",
                "Jam, Apricot",
                "Jam, Rasberry",
                "Jam, Strawberry",
                "Jam, Blueberry",
                "Jam, Blackberry",
                ])
            createCategory("Spices",[
                "Coconut, Flakes",
                "Basil",
                "Cinnamon",
                "Ginger",
                "Oregano",
                "Chilli Powder",
                "Coriander",
                "Mint",
                "Paprika",
                "Star Anise",
                "Vanilla",
                "Pepper",
                "Sugar",
                "Salt", "Salt, Sea", "Salt, Sea + Iodine",
                ])
        }
        
        
    }
    
}
