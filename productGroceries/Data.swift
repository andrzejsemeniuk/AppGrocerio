//
//  ItemsData.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Data : NSObject
{
    struct Item
    {
        var name:       String
        var category:   String
        var quantity:   Int         = 0
        var note:       String      = ""
        
        static func create(name name:String, category:String, quantity:Int = 0, note:String = "") -> Item {
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
            return [quantity,note,name,category]
        }
        
        static func deserialize(name:String, category:String, from:[AnyObject]) -> Item {
            return Item(name:name,category:category,quantity:from[0] as! Int,note:from[1] as! String)
        }
        
        static func deserialize(from:[AnyObject]) -> Item {
            return Item(name:from[2] as! String,category:from[3] as! String,quantity:from[0] as! Int,note:from[1] as! String)
        }
    }
    
    
    
    class Manager : NSObject
    {
        enum Key: String {
            case Categories, Items
            
            case SettingsBackgroundColor                        = "settings-background"
            case SettingsAudioOn                                = "settings-audio-on"
            case SettingsSelectionColor                         = "settings-selection-color"
            case SettingsSelectionColorOpacity                  = "settings-selection-color-opacity"
            
            case SettingsTabCategoriesUppercase                 = "settings-categories-uppercase"
            case SettingsTabCategoriesEmphasize                 = "settings-categories-emphasize"
            case SettingsTabCategoriesFont                      = "settings-categories-font"
            case SettingsTabCategoriesTheme                     = "settings-categories-theme"
            case SettingsTabCategoriesTextColor                 = "settings-categories-text-color"
            case SettingsTabItemsFont                           = "settings-items-font"
            case SettingsTabItemsUppercase                      = "settings-items-uppercase"
            case SettingsTabItemsEmphasize                      = "settings-items-emphasize"
            case SettingsTabItemsFontSameAsCategories           = "settings-items-font-as-categories"
            case SettingsTabItemsTextColor                      = "settings-items-text-color"
            case SettingsTabItemsTextColorSameAsCategories      = "settings-items-text-color-as-categories"
            case SettingsTabItemsRowOddOpacity                  = "settings-items-row-odd-alpha"
            case SettingsTabItemsRowEvenOpacity                 = "settings-items-row-even-alpha"
            case SettingsTabItemsQuantityColorBackground        = "settings-items-quantity-color-bg"
            case SettingsTabItemsQuantityColorBackgroundOpacity = "settings-items-quantity-color-bg-opacity"
            case SettingsTabItemsQuantityColorText              = "settings-items-quantity-color-text"
            case SettingsTabItemsQuantityColorTextSameAsItems   = "settings-items-quantity-color-text-as-items"
            case SettingsTabItemsQuantityFont                   = "settings-items-quantity-font"
            case SettingsTabItemsQuantityFontSameAsItems        = "settings-items-quantity-font-as-items"
            
            case SettingsTabThemesSolidColor                    = "settings-themes-solid-color"
            case SettingsTabThemesRangeFromColor                = "settings-themes-range-color-from"
            case SettingsTabThemesRangeToColor                  = "settings-themes-range-color-to"
            case SettingsTabThemesCustomColors                  = "settings-themes-custom-colors"
            case SettingsTabThemesName                          = "settings-themes-name"
            case SettingsTabThemesSaturation                    = "settings-themes-saturation"
            
            case SettingsCurrent                                = "settings:current"
            case SettingsList                                   = "settings-list"
            case SettingsLastName                               = "settings-last-name"
            
            case SummaryList                                    = "summary-list"
        }
        
        
        
        private class func itemsKey(category:String) -> String {
            return "category:"+category
        }
        
        
        
        
        class func itemPut              (item:Item,addQuantity:Bool = false)
        {
            // if item does not exit
            //  insert
            // else
            //  update
            
            var item = item
            
            if true
            {
                do {
                    let entityDescription   = NSEntityDescription.entityForName("Item", inManagedObjectContext: AppDelegate.managedObjectContext)
                    
                    let set                 = { (newItem:NSManagedObject) in
                        newItem.setValue(item.name,         forKey:"name")
                        newItem.setValue(item.category,     forKey:"category")
                        newItem.setValue(item.quantity,     forKey:"quantity")
                        newItem.setValue(item.note,         forKey:"note")
                    }
                    
                    let create              = {
                        let newItem             = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: AppDelegate.managedObjectContext)
                        set(newItem)
                        try newItem.managedObjectContext?.save()
                    }
                    
                    let update              = { (newItem:NSManagedObject) in
                        if addQuantity {
                            var quantity = newItem.valueForKey("quantity") as? Int ?? 0
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
                    
                    let request             = NSFetchRequest()
                    
                    request.entity          = entityDescription
                    
                    request.predicate       = NSPredicate(format:"(name = %@) AND (category = %@)", item.name, item.category)
                    
                    do {
                        let result          = try AppDelegate.managedObjectContext.executeFetchRequest(request)
                        
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
                let defaults = NSUserDefaults.standardUserDefaults()
                
                let key = itemsKey(item.category)
                
                var all = defaults.dictionaryForKey(key)
                
                if all == nil {
                    all = [String:AnyObject]()
                }
                
                all![item.name] = item.serialize()
                
                defaults.setObject(all!,forKey:key)
            }
        }
        
        class func itemReset           (item:Item)
        {
            // if item exists
            //  reset it
            
            if true {
                itemPut(Item(name:item.name,category:item.category,quantity:0,note:""))
            }
            else {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                let key = itemsKey(item.category)
                
                if var all = defaults.dictionaryForKey(key) {
                    all.removeValueForKey(item.name)
                    var item1 = item
                    item1.reset()
                    all[item.name] = item1.serialize()
                    defaults.setObject(all,forKey:key)
                }
            }
        }
        
        class func itemRemove           (item:Item)
        {
            // if item exists
            //  remove it
            
            if true {
                let entityDescription   = NSEntityDescription.entityForName("Item", inManagedObjectContext: AppDelegate.managedObjectContext)
                let oldItem             = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: AppDelegate.managedObjectContext)
                
                oldItem.setValue(item.name,         forKey:"name")
                oldItem.setValue(item.category,     forKey:"category")
//                oldItem.setValue(item.quantity,     forKey:"quantity")
//                oldItem.setValue(item.note,         forKey:"note")

                AppDelegate.managedObjectContext.deleteObject(oldItem)
            }
            else {
                let key = itemsKey(item.category)
                
                let defaults = NSUserDefaults.standardUserDefaults()
                
                if var all = defaults.dictionaryForKey(key) {
                    all.removeValueForKey(item.name)
                    defaults.setObject(all,forKey:key)
                }
            }
        }
        
        class func itemRemoveAll            ()
        {
            let fetchRequest        = NSFetchRequest(entityName: "Item")
            let deleteRequest       = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try AppDelegate.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: AppDelegate.managedObjectContext)
            } catch let error as NSError {
                print(error)
            }
        }
        
        class func itemGetAllInCategory   (category:String, sorted:Bool = true) -> [Item]
        {
            // return all items in category
            
            var results:[Item] = []
            
            if true {
                let request             = NSFetchRequest()
                
                let entityDescription   = NSEntityDescription.entityForName("Item", inManagedObjectContext: AppDelegate.managedObjectContext)
                
                request.entity          = entityDescription

                request.predicate       = NSPredicate(format:"%K = %@", "category", category)
                
                do {
                    let result          = try AppDelegate.managedObjectContext.executeFetchRequest(request)
//                    print(result)
                    
                    var anItem:Item = Item(name:"",category:"",quantity:0,note:"")
                    
                    for object in result {
//                        print("object=\(object)")
                        anItem.name     = object.valueForKey("name") as! String
                        anItem.category = object.valueForKey("category") as! String
                        anItem.quantity = object.valueForKey("quantity") as! Int
                        anItem.note     = object.valueForKey("note") as! String
                        
                        results.append(anItem)
                    }
                    
                } catch {
                    let fetchError      = error as NSError
                    print(fetchError)
                }
            }
            else {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                if let all = defaults.dictionaryForKey(itemsKey(category)) {
                    for (key,value) in all {
                        if let array = value as? Array<AnyObject> {
                            results.append(Item.deserialize(key, category:category, from:array))
                        }
                    }
                }
            }
            
            return sorted ? results.sort { $0.name < $1.name } : results
        }
        
        
        
        
        class func categoryAdd          (newCategory:String) -> Bool
        {
            var result = false
            
            let category = newCategory.trimmed()
            
            if !category.empty {
                var categories = categoryGetAll()
                if !categories.contains(category) {
                    categories.append(category)
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(categories, forKey:Key.Categories.rawValue)
                    result = true
                }
            }
            
            return result
        }
        
        class func categoryReset        (category:String)
        {
            for item in itemGetAllInCategory(category,sorted:false) {
                itemReset(item)
            }
        }
        
        class func categoryRemove       (oldCategory:String) -> Bool
        {
            var result = false
            
            let category = oldCategory.trimmed()
            
            if !category.empty {
                let categories0 = categoryGetAll()
                let categories1 = categories0.filter({ $0 != category })
                
                if categories1.count < categories0.count {
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(categories1, forKey:Key.Categories.rawValue)
                    defaults.removeObjectForKey(itemsKey(category))
                    result = true
                }
            }
            
            return result
        }
        
        class func categoryClearAll      ()
        {
            for category in categoryGetAll() {
                categoryRemove(category)
            }
        }
        
        class func categoryGetAll        () -> [String]
        {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            var result = [String]()
            
            if let categories = defaults.arrayForKey(Key.Categories.rawValue) {
                for category in categories {
                    result.append(category as! String)
                }
            }
            
            return result.sort { return $0 < $1 }
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
            if let defaults = NSUserDefaults.standardUserDefaults().dictionaryForKey(Key.SettingsCurrent.rawValue) {
                return defaults
            }
            
            let defaults = [String:AnyObject]()
            
            NSUserDefaults.standardUserDefaults().setObject(defaults,forKey:Key.SettingsCurrent.rawValue)
            
            return defaults
        }
        
        
        
        
        class func settingsGetBoolForKey(key:Key, defaultValue:Bool = false) -> Bool
        {
            if let result = settingsGetCurrent()["b:"+key.rawValue] as? Bool {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetBool(value:Bool, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["b:"+forKey.rawValue] = value
            
            NSUserDefaults.standardUserDefaults().setObject(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsGetFloatForKey(key:Key, defaultValue:Float = 0) -> Float
        {
            if let result = settingsGetCurrent()["f:"+key.rawValue] as? Float {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetFloat(value:Float, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["f:"+forKey.rawValue] = value
            
            NSUserDefaults.standardUserDefaults().setObject(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsGetStringForKey(key:Key, defaultValue:String = "") -> String
        {
            if let result = settingsGetCurrent()["s:"+key.rawValue] as? String {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetString(value:String, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["s:"+forKey.rawValue] = value
            
            NSUserDefaults.standardUserDefaults().setObject(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsPackColor(value:UIColor) -> [Float]
        {
            let rgba = value.RGBA()
            
            let RGBA:[Float] = [
                Float(rgba.red),
                Float(rgba.green),
                Float(rgba.blue),
                Float(rgba.alpha)
            ]
            
            return RGBA
        }
        
        class func settingsUnpackColor(value:[Float], defaultValue:UIColor) -> UIColor
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
        
        class func settingsGetColorForKey(key:Key, defaultValue:UIColor = UIColor.blackColor()) -> UIColor
        {
            if let result = settingsGetCurrent()["c:"+key.rawValue] as? [Float] {
                return settingsUnpackColor(result,defaultValue:defaultValue)
            }
            return defaultValue
        }
        
        class func settingsSetColor(value:UIColor, forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["c:"+forKey.rawValue] = settingsPackColor(value)
            
            NSUserDefaults.standardUserDefaults().setObject(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        class func settingsGetArrayForKey(key:Key, defaultValue:[AnyObject] = []) -> [AnyObject]
        {
            if let result = settingsGetCurrent()["A:"+key.rawValue] as? [AnyObject] {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetArray(value:[AnyObject], forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["A:"+forKey.rawValue] = value
            
            NSUserDefaults.standardUserDefaults().setObject(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        
        class func settingsGetDictionaryForKey(key:Key, defaultValue:[String:AnyObject] = [:]) -> [String:AnyObject]
        {
            if let result = settingsGetCurrent()["D:"+key.rawValue] as? [String:AnyObject] {
                return result
            }
            return defaultValue
        }
        
        class func settingsSetDictionary(value:[String:AnyObject], forKey:Key)
        {
            var defaults = settingsGetCurrent();
            
            defaults["D:"+forKey.rawValue] = value
            
            NSUserDefaults.standardUserDefaults().setObject(defaults,forKey:Key.SettingsCurrent.rawValue)
        }
        
        
        
        
        
        class func settingsGetCategoriesFont(defaultValue:UIFont? = nil) -> UIFont
        {
            var defaultValue = defaultValue
            
            if defaultValue == nil {
                defaultValue = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            }
            
            if let result = UIFont(name:settingsGetStringForKey(.SettingsTabCategoriesFont,defaultValue:defaultValue!.familyName), size:defaultValue!.pointSize) {
                return result
            }
            
            return defaultValue!
        }
        
        class func settingsGetItemsFont(defaultValue:UIFont? = nil) -> UIFont
        {
            if settingsGetBoolForKey(.SettingsTabItemsFontSameAsCategories) {
                return settingsGetCategoriesFont()
            }
            
            var defaultValue = defaultValue
            
            if defaultValue == nil {
                defaultValue = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            }
            
            if let result = UIFont(name:settingsGetStringForKey(.SettingsTabItemsFont,defaultValue:defaultValue!.familyName), size:defaultValue!.pointSize) {
                return result
            }
            
            return defaultValue!
        }
        
        class func settingsGetItemsQuantityFont(defaultValue:UIFont? = nil) -> UIFont
        {
            if settingsGetBoolForKey(.SettingsTabItemsQuantityFontSameAsItems) {
                return settingsGetItemsFont()
            }
            
            var defaultValue = defaultValue
            
            if defaultValue == nil {
                defaultValue = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            }
            
            if let result = UIFont(name:settingsGetStringForKey(.SettingsTabItemsQuantityFont,defaultValue:defaultValue!.familyName), size:defaultValue!.pointSize) {
                return result
            }
            
            return defaultValue!
        }
        
        
        
        
        
        class func settingsGetBackgroundColor(defaultValue:UIColor = UIColor(hue:0.9)) -> UIColor
        {
            return settingsGetColorForKey(.SettingsBackgroundColor,defaultValue:defaultValue)
        }
        
        class func settingsGetSelectionColor(defaultValue:UIColor = UIColor(gray:1,alpha:0.2)) -> UIColor
        {
            let hsba    = settingsGetColorForKey(.SettingsSelectionColor,defaultValue:defaultValue).HSBA()
            
            let opacity = settingsGetFloatForKey(.SettingsSelectionColorOpacity,defaultValue:Float(defaultValue.alpha()))
            
            return UIColor(hue:hsba.hue,saturation:hsba.saturation,brightness:hsba.brightness,alpha:CGFloat(opacity))
        }
        

        
        class func settingsGetCategoriesTextColor(defaultValue:UIColor = UIColor(hue:0.87)) -> UIColor
        {
            return settingsGetColorForKey(.SettingsTabCategoriesTextColor,defaultValue:defaultValue)
        }
        
        class func settingsGetItemsTextColor(defaultValue:UIColor = UIColor(hue:0.95)) -> UIColor
        {
            if settingsGetBoolForKey(.SettingsTabItemsTextColorSameAsCategories) {
                return settingsGetCategoriesTextColor()
            }
            
            return settingsGetColorForKey(.SettingsTabItemsTextColor,defaultValue:defaultValue)
        }
        
        class func settingsGetItemsQuantityBackgroundColorWithOpacity(opacityOn:Bool) -> UIColor
        {
            let color0  = UIColor.redColor()
            
            let color1  = settingsGetColorForKey(.SettingsTabItemsQuantityColorBackground,defaultValue:color0)
            
            let alpha   = opacityOn ? settingsGetFloatForKey(.SettingsTabItemsQuantityColorBackgroundOpacity,defaultValue:0.8) : 0.8
            
            return color1.colorWithAlphaComponent(CGFloat(alpha))
        }
        
        class func settingsGetItemsQuantityTextColor(defaultValue:UIColor = UIColor.whiteColor()) -> UIColor
        {
            if settingsGetBoolForKey(.SettingsTabItemsQuantityColorTextSameAsItems) {
                return settingsGetItemsTextColor()
            }
            
            return settingsGetColorForKey(.SettingsTabItemsQuantityColorText,defaultValue:defaultValue)
        }
        
        
        
        
        
        
        
        class func settingsSetThemeWithName(name:String)
        {
            settingsSetString(name,forKey:Key.SettingsTabThemesName)
        }
        
        
        
        
        
        
        
        class func settingsGetThemeName(defaultValue:String = "Plain") -> String
        {
            return settingsGetStringForKey(Key.SettingsTabThemesName,defaultValue:defaultValue)
        }
        
        
        
        
        
        
        
        class func settingsGetThemesSolidColor(defaultValue:UIColor = UIColor.redColor()) -> UIColor
        {
            return settingsGetColorForKey(.SettingsTabThemesSolidColor,defaultValue:defaultValue)
        }
        
        class func settingsGetThemesRangeFromColor(defaultValue:UIColor = UIColor.yellowColor()) -> UIColor
        {
            return settingsGetColorForKey(.SettingsTabThemesRangeFromColor,defaultValue:defaultValue)
            //        let dictionary = settingsGetDictionaryForKey(.SettingsTabThemesRangeColors)
            //
            //        if let color = dictionary["from"] as? [Float] {
            //            return settingsUnpackColor(color,defaultValue:defaultValue)
            //        }
            //
            //        return defaultValue
        }
        
        class func settingsGetThemesRangeToColor(defaultValue:UIColor = UIColor.orangeColor()) -> UIColor
        {
            return settingsGetColorForKey(.SettingsTabThemesRangeToColor,defaultValue:defaultValue)
            //        let dictionary = settingsGetDictionaryForKey(.SettingsTabThemesRangeColors)
            //
            //        if let color = dictionary["to"] as? [Float] {
            //            return settingsUnpackColor(color,defaultValue:defaultValue)
            //        }
            //
            //        return defaultValue
        }
        
        
        
        class func settingsSetThemesSolidColor(color:UIColor)
        {
            settingsSetColor(color,forKey:.SettingsTabThemesSolidColor)
        }
        
        class func settingsSetThemesRangeFromColor(color:UIColor)
        {
            settingsSetColor(color,forKey:.SettingsTabThemesRangeFromColor)
            //        var dictionary = settingsGetDictionaryForKey(.SettingsTabThemesRangeColors)
            //        dictionary["from"] = settingsPackColor(color)
            //        settingsSetDictionary(dictionary,forKey:.SettingsTabThemesRangeColors)
        }
        
        class func settingsSetThemesRangeToColor(color:UIColor)
        {
            settingsSetColor(color,forKey:.SettingsTabThemesRangeToColor)
            //        var dictionary = settingsGetDictionaryForKey(.SettingsTabThemesRangeColors)
            //        dictionary["to"] = settingsPackColor(color)
            //        settingsSetDictionary(dictionary,forKey:.SettingsTabThemesRangeColors)
        }
        
        
        
        
        
        
        class func displayHelpPageForCategories(controller:ControllerOfCategories)
        {
            let key = "display-help-categories"
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if !defaults.boolForKey(key) {
                defaults.setBool(true,forKey:key)
                
                let alert = UIAlertController(title:"Categories", message:"Welcome!  Add new categories by tapping on the plus button "
                    + "in the top right corner.  Remove categories by swiping from right to left.", preferredStyle:.Alert)
                
                let actionOK = UIAlertAction(title:"OK", style:.Cancel, handler: {
                    action in
                })
                
                alert.addAction(actionOK)
                
                controller.presentViewController(alert, animated:true, completion: {
                    print("completed showing add alert")
                })
            }
        }
        
        
        class func displayHelpPageForItems(controller:ItemsController)
        {
            let key = "display-help-items"
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if !defaults.boolForKey(key) {
                defaults.setBool(true,forKey:key)
                
                let alert = UIAlertController(title:"Items", message:"Tap on the right side of an item to increase its quantity.  Tap on the left side to decrease its quantity.", preferredStyle:.Alert)
                
                let actionOK = UIAlertAction(title:"OK", style:.Cancel, handler: {
                    action in
                })
                
                alert.addAction(actionOK)
                
                controller.presentViewController(alert, animated:true, completion: {
                    print("completed showing add alert")
                })
                
            }
        }
        
        
        class func displayHelpPageForSummary(controller:ControllerOfSummary)
        {
            let key = "display-help-summary"
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if !defaults.boolForKey(key) {
                defaults.setBool(true,forKey:key)
                
                let alert = UIAlertController(title:"Summary", message:"This page presents a list of items you selected in categories.  Remove an item by swiping from right to left.", preferredStyle:.Alert)
                
                let actionOK = UIAlertAction(title:"OK", style:.Cancel, handler: {
                    action in
                })
                
                alert.addAction(actionOK)
                
                controller.presentViewController(alert, animated:true, completion: {
                    print("completed showing add alert")
                })
                
            }
        }
        
        class func clearHelpFlags()
        {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.removeObjectForKey("display-help-categories")
            defaults.removeObjectForKey("display-help-items")
            defaults.removeObjectForKey("display-help-summary")
        }
        
        class func migrateItemsIfRequired()
        {
            let request             = NSFetchRequest()
            
            request.entity          = NSEntityDescription.entityForName("Item", inManagedObjectContext: AppDelegate.managedObjectContext)
            
            do {
                let result          = try AppDelegate.managedObjectContext.executeFetchRequest(request)
                
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
            
            
            //            case SettingsTabCategoriesUppercase                 = "settings-categories-uppercase"
            //            case SettingsTabCategoriesEmphasize                 = "settings-categories-emphasize"
            //            case SettingsTabCategoriesFont                      = "settings-categories-font"
            //            case SettingsTabCategoriesTheme                     = "settings-categories-theme"
            //            case SettingsTabCategoriesTextColor                 = "settings-categories-text-color"
            //            case SettingsTabItemsFont                           = "settings-items-font"
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
            //            case SettingsTabItemsQuantityFontSameAsItems        = "settings-items-quantity-font-as-items"
            //
            //            case SettingsTabThemesSolidColor                    = "settings-themes-solid-color"
            //            case SettingsTabThemesRangeFromColor                = "settings-themes-range-color-from"
            //            case SettingsTabThemesRangeToColor                  = "settings-themes-range-color-to"
            //            case SettingsTabThemesCustomColors                  = "settings-themes-custom-colors"
            //            case SettingsTabThemesName                          = "settings-themes-name"
            //            case SettingsTabThemesSaturation                    = "settings-themes-saturation"
            
            
            
            do
            {
                
                settingsUse                                 ("Default")
                
                settingsSetColor                            (UIColor(hue:0.4)                                   ,forKey:.SettingsBackgroundColor)
                
                settingsSetBool                             (false                                              ,forKey:.SettingsTabCategoriesUppercase)
                settingsSetBool                             (false                                              ,forKey:.SettingsTabCategoriesEmphasize)
                settingsSetString                           ("Helvetica-Bold"                                   ,forKey:.SettingsTabCategoriesFont)
                settingsSetColor                            (UIColor(hue:0,saturation:1,brightness:1)           ,forKey:.SettingsTabCategoriesTextColor)
                
                //            settingsSetThemesSolidColor                 (UIColor.whiteColor())
                settingsSetThemeWithName                    ("Plain")
                
                
                settingsSetString                           ("Helvetica"                                        ,forKey:.SettingsTabItemsFont)
                settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsUppercase)
                settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsEmphasize)
                //            settingsSetBool                             (true                                               ,forKey:.SettingsTabItemsFontSameAsCategories)
                settingsSetColor                            (UIColor(hue:0.0,saturation:1,brightness:1)         ,forKey:.SettingsTabItemsTextColor)
                //            settingsSetBool                             (true                                               ,forKey:.SettingsTabItemsTextColorSameAsCategories)
                settingsSetFloat                            (0.30                                               ,forKey:.SettingsTabItemsRowOddOpacity)
                settingsSetFloat                            (0.70                                               ,forKey:.SettingsTabItemsRowEvenOpacity)
                
                settingsSetColor                            (UIColor(hue:0,saturation:1,brightness:1)           ,forKey:.SettingsTabItemsQuantityColorBackground)
                settingsSetFloat                            (1.00                                               ,forKey:.SettingsTabItemsQuantityColorBackgroundOpacity)
                settingsSetColor                            (UIColor(hue:0,saturation:0,brightness:1)           ,forKey:.SettingsTabItemsQuantityColorText)
                //            settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsQuantityColorTextSameAsItems)
                settingsSetString                           ("Helvetica"                                        ,forKey:.SettingsTabItemsQuantityFont)
                //            settingsSetBool                             (false                                              ,forKey:.SettingsTabItemsQuantityFontSameAsItems)
                
                settingsSave                                ("Default")
            }

            
            
            
            
            do
            {
                settingsUse                                 ("Chalkboard")
                
                settingsSetThemesRangeFromColor             (UIColor(hue:0.40,brightness:0.83))
                settingsSetThemesRangeToColor               (UIColor(hue:0.40,brightness:0.85))
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
                settingsSetFloat                            (0.10                                               ,forKey:.SettingsTabItemsQuantityColorBackgroundOpacity)

                settingsSetColor                            (UIColor(hue:0.30,saturation:0.80,brightness:1.00)  ,forKey:.SettingsSelectionColor)
                settingsSetFloat                            (0.50                                               ,forKey:.SettingsSelectionColorOpacity)

                settingsSetColor                            (UIColor(hue:0.40,brightness:0.80)                  ,forKey:.SettingsBackgroundColor)
                
                settingsSave                                ("Chalkboard")
            }
            

            do
            {
                settingsUse                                 ("Honey")
                
                settingsSetThemesRangeFromColor             (UIColor(hue:0.10,brightness:1.00))
                settingsSetThemesRangeToColor               (UIColor(hue:0.13,brightness:1.00))
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
                settingsSetColor                            (UIColor(hue:0.05,saturation:1.00,brightness:0.10)  ,forKey:.SettingsTabItemsQuantityColorBackground)
                settingsSetFloat                            (0.10                                               ,forKey:.SettingsTabItemsQuantityColorBackgroundOpacity)
                
                settingsSetColor                            (UIColor(hue:0.00,saturation:0.80,brightness:1.00)  ,forKey:.SettingsSelectionColor)
                settingsSetFloat                            (0.50                                               ,forKey:.SettingsSelectionColorOpacity)
                
                settingsSetColor                            (UIColor(hue:0.08,brightness:1.00)                  ,forKey:.SettingsBackgroundColor)
                
                settingsSave                                ("Honey")
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
                categoryRemove(category)
            }
            
            createCategories()
            
            settingsSetBool(true,forKey:.SettingsTabCategoriesEmphasize)
            //        settingsSetBool(true,forKey:.SettingsTabCategoriesUppercase)
        }
        
        class func synchronize()
        {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.synchronize()
        }
        
        
        
        
        
        class func settingsGetLastName(defaultValue:String = "") -> String
        {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let result = defaults.stringForKey(Key.SettingsLastName.rawValue) {
                return result
            }
            
            return defaultValue
        }
        
        private class func settingsKeyForName(name:String) -> String {
            return "settings="+name
        }
        
        
        class func settingsExist    (var name:String) -> Bool
        {
            var result = false
            
            name = name.trimmed()
            
            if 0 < name.length
            {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                if let settings = defaults.dictionaryForKey(settingsKeyForName(name))
                {
                    result = true
                }
            }
            
            return result
        }
        
        class func settingsUse      (var name:String) -> Bool
        {
            var result = false
            
            name = name.trimmed()
            
            if 0 < name.length
            {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                if let settings = defaults.dictionaryForKey(settingsKeyForName(name))
                {
                    defaults.setObject(settings,forKey:Key.SettingsCurrent.rawValue)
                    
                    defaults.setObject(name,forKey:Key.SettingsLastName.rawValue)
                    
                    result = true
                }
            }
            
            return result
        }
        
        class func settingsRemove    (var name:String) -> Bool
        {
            var result = false
            
            name = name.trimmed()
            
            if 0 < name.length
            {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                defaults.removeObjectForKey(settingsKeyForName(name))
                
                do
                {
                    var list = Set<String>(settingsList())
                    
                    list.remove(name)
                    
                    let array = Array(list)
                    
                    defaults.setObject(array,forKey:Key.SettingsList.rawValue)
                }
                
                result = true
            }
            
            return result
        }
        
        class func settingsSave     (var name:String) -> Bool
        {
            var result = false
            
            name = name.trimmed()
            
            if 0 < name.length
            {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                if let settings = defaults.dictionaryForKey(Key.SettingsCurrent.rawValue)
                {
                    defaults.setObject(settings,forKey:settingsKeyForName(name))
                    
                    defaults.setObject(name,forKey:Key.SettingsLastName.rawValue)
                    
                    do
                    {
                        var list = Set<String>(settingsList())
                        
                        list.insert(name)
                        
                        let array = Array(list)
                        
                        defaults.setObject(array,forKey:Key.SettingsList.rawValue)
                    }
                    
                    result = true
                }
            }
            
            return result
        }
        
        class func settingsListIsEmpty() -> Bool
        {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let array = defaults.arrayForKey(Key.SettingsList.rawValue)
            
            return array == nil || 0 == array!.count
        }
        
        class func settingsList     () -> [String]
        {
            var result:[String] = []
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let array = defaults.arrayForKey(Key.SettingsList.rawValue) {
                
                for element in array {
                    
                    result.append(element as! String)
                    
                }
            }
            
            return result
        }
        
        
        
        
        
        private class func summaryKeyForName(name:String) -> String {
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
        
        class func summaryAdd       (name:String) -> Bool
        {
            var result = false
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let summary = defaults.arrayForKey(summaryKeyForName(name)) {
                
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
        
        class func summaryUse       (name:String) -> Bool
        {
            var result = false
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let summary = defaults.arrayForKey(summaryKeyForName(name)) {
                
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
        
        class func summarySave      (name:String) -> Bool
        {
            var result = false
            
            if 0 < name.length
            {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                var items = [AnyObject]()
                
                for item in summaryGet() {
                    items.append(item.serialize())
                }
                
                defaults.setObject(items,forKey:summaryKeyForName(name))
                
                do
                {
                    var list = Set<String>(summaryList())
                    
                    list.insert(name)
                    
                    let array = Array(list)
                    
                    defaults.setObject(array,forKey:Key.SummaryList.rawValue)
                }
                
                result = true
            }
            
            return result
        }
        
        class func summaryList      () -> [String]
        {
            var result:[String] = []
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let array = defaults.arrayForKey(Key.SummaryList.rawValue) {
                
                for element in array {
                    
                    result.append(element as! String)
                }
            }
            
            return result.sort()
        }
        
        
        
        
        
        class func createCategories ()
        {
            let createCategory = { (name:String, items:[String]) in
                let category = name.trimmed()
                if 0 < category.length {
                    categoryAdd(category)
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