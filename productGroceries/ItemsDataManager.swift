//
//  ItemsData.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit


struct Item
{
    let name:       String
    let category:   String
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
        return [quantity,note]
    }
    
    static func deserialize(name:String, category:String, from:[AnyObject]) -> Item {
        return Item(name:name,category:category,quantity:from[0] as! Int,note:from[1] as! String)
    }
}



class ItemsDataManager : NSObject
{
    enum Key: String {
        case Categories, Items
        case SettingsTabCategoriesUppercase                 = "settings-categories-uppercase"
        case SettingsTabCategoriesEmphasize                 = "settings-categories-emphasize"
        case SettingsTabCategoriesFont                      = "settings-categories-font"
        case SettingsTabCategoriesTheme                     = "settings-categories-theme"
        case SettingsTabCategoriesTextColor                 = "settings-categories-text-color"
        case SettingsTabItemsFont                           = "settings-items-font"
        case SettingsTabItemsTextColor                      = "settings-items-text-color"
        case SettingsTabItemsRowOddTransparency             = "settings-items-row-odd-alpha"
        case SettingsTabItemsRowEvenTransparency            = "settings-items-row-even-alpha"
        case SettingsTabItemsQuantityColorBackground        = "settings-items-quantity-color-bg"
        case SettingsTabItemsQuantityColorText              = "settings-items-quantity-color-text"
        case SettingsTabSummaryQuantityColorBackground      = "settings-summary-quantity-color-bg"
        case SettingsTabSummaryQuantityColorText            = "settings-summary-quantity-color-text"
        case SettingsTabSummaryQuantityUseItems             = "settings-summary-quantity-use-items"
    }
    
    
    
    private class func itemsKey(category:String) -> String {
        return "category:"+category
    }
    
    class func putItem              (item:Item)
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
    
    class func resetItem           (item:Item)
    {
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
    
    class func removeItem           (item:Item)
    {
        let key = itemsKey(item.category)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if var all = defaults.dictionaryForKey(key) {
            all.removeValueForKey(item.name)
            defaults.setObject(all,forKey:key)
        }
    }
    
    class func allItemsInCategory   (category:String, sorted:Bool = true) -> [Item]
    {
        var result:[Item] = []
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let all = defaults.dictionaryForKey(itemsKey(category)) {
            for (key,value) in all {
                if let array = value as? Array<AnyObject> {
                    result.append(Item.deserialize(key, category:category, from:array))
                }
            }
        }
        
        return sorted ? result.sort { $0.name < $1.name } : result
    }
    
    
    
    
    class func addCategory          (newCategory:String) -> Bool
    {
        var result = false
        
        let category = newCategory.trimmed()
        
        if !category.empty {
            var categories = allCategories()
            if !categories.contains(category) {
                categories.append(category)
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(categories, forKey:Key.Categories.rawValue)
                result = true
            }
        }
        
        return result
    }
    
    class func resetCategory        (category:String)
    {
        for item in allItemsInCategory(category,sorted:false) {
            resetItem(item)
        }
    }
    
    class func removeCategory       (oldCategory:String) -> Bool
    {
        var result = false
        
        let category = oldCategory.trimmed()
        
        if !category.empty {
            let categories0 = allCategories()
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
    
    class func clearCategories      ()
    {
        for category in allCategories() {
            removeCategory(category)
        }
    }
    
    class func allCategories        () -> [String]
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
        
        for category in allCategories() {
            var add = [Item]()
            for item in allItemsInCategory(category,sorted:true) {
                if item.isModified() {
                    add.append(item)
                }
            }
            if 0 < add.count {
                result.append(add)
            }
        }
        
        return result
    }
    
    
    
    
    class func settingsGetBoolForKey(key:Key, defaultValue:Bool = false) -> Bool
    {
        return NSUserDefaults.standardUserDefaults().boolForKey(key.rawValue)
    }
    
    class func settingsSetBool(value:Bool, forKey:Key)
    {
        NSUserDefaults.standardUserDefaults().setBool(value,forKey:forKey.rawValue)
    }
    
    class func settingsGetFloatForKey(key:Key, defaultValue:Float = 0) -> Float
    {
        return NSUserDefaults.standardUserDefaults().floatForKey(key.rawValue)
    }
    
    class func settingsSetFloat(value:Float, forKey:Key)
    {
        NSUserDefaults.standardUserDefaults().setFloat(value,forKey:forKey.rawValue)
    }
    
    class func settingsGetStringForKey(key:Key, defaultValue:String = "") -> String
    {
        if let result = NSUserDefaults.standardUserDefaults().stringForKey(key.rawValue) {
            return result
        }
        return defaultValue
    }
    
    class func settingsSetString(value:String, forKey:Key)
    {
        NSUserDefaults.standardUserDefaults().setObject(value,forKey:forKey.rawValue)
    }
    
    class func settingsGetColorForKey(key:Key, defaultValue:UIColor = UIColor.blackColor()) -> UIColor
    {
        if let result = NSUserDefaults.standardUserDefaults().objectForKey(key.rawValue) as? [Float] {
            return UIColor.RGBA(result[0],result[1],result[2],result[3])
        }
        return defaultValue
    }
    
    class func settingsSetColor(value:UIColor, forKey:Key)
    {
        let rgba = value.RGBA()
        
        let RGBA:[Float] = [
            rgba.red,
            rgba.green,
            rgba.blue,
            rgba.alpha
        ]
        NSUserDefaults.standardUserDefaults().setObject(RGBA,forKey:forKey.rawValue)
    }
    
    
    
    
    
    
    class func settingsGetItemsFont() -> UIFont
    {
        let font0 = UIFont.systemFontOfSize(UIFont.labelFontSize())

        if let result = UIFont(name:settingsGetStringForKey(.SettingsTabItemsFont,defaultValue:font0.familyName), size:font0.pointSize) {
            return result
        }
        
        return UIFont.systemFontOfSize(UIFont.labelFontSize())
    }
    
    class func settingsGetCategoriesFont() -> UIFont
    {
        let font0 = UIFont.systemFontOfSize(UIFont.labelFontSize())
        
        if let result = UIFont(name:settingsGetStringForKey(.SettingsTabCategoriesFont,defaultValue:font0.familyName), size:font0.pointSize) {
            return result
        }
        
        return UIFont.systemFontOfSize(UIFont.labelFontSize())
    }
    
    

    
    class func settingsGetCategoriesTextColor() -> UIColor
    {
        let color0 = UIColor.grayColor()
        
        return settingsGetColorForKey(.SettingsTabCategoriesTextColor,defaultValue:color0)
    }
    
    class func settingsGetItemsTextColor() -> UIColor
    {
        let color0 = UIColor.grayColor()
        
        return settingsGetColorForKey(.SettingsTabItemsTextColor,defaultValue:color0)
    }
    
    
    

    
    
    class func displayHelpPageForCategories(controller:CategoriesController)
    {
        let key = "display-help-categories"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if !defaults.boolForKey(key) {
            defaults.setBool(true,forKey:key)
            
            let alert = UIAlertController(title:"Categories", message:"Welcome!  Add new categories by tapping on the plus button "
                + "in the top right corner.  Remove categories permanently by swiping from right to left.", preferredStyle:.Alert)
            
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
    
    
    class func displayHelpPageForSummary(controller:SummaryController)
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
    
    class func resetIfEmpty()
    {
        let categories = allCategories()
        
        if categories.count < 1 {
            reset()
        }
    }
    
    class func reset()
    {
        let categories = allCategories()
        
        // empty,0 => yes
        // empty,n => no
        // not empty,0 => yes
        // not empty,n => yes
        
        
        
        for category in categories {
            removeCategory(category)
        }
        
        addCategory("Produce")
        putItem(Item.create(name:"Lettuce, Iceberg",category:"Produce"))
        putItem(Item.create(name:"Lettuce, Romaine",category:"Produce"))
        putItem(Item.create(name:"Cabbage",category:"Produce"))
        putItem(Item.create(name:"Tomatoes",category:"Produce"))
        putItem(Item.create(name:"Tomatoes, Roma",category:"Produce"))
        putItem(Item.create(name:"Potatoes",category:"Produce"))
        putItem(Item.create(name:"Potatoes, Russett",category:"Produce"))
        putItem(Item.create(name:"Potatoes, Golden",category:"Produce"))
        putItem(Item.create(name:"Garlic",category:"Produce"))
        putItem(Item.create(name:"Onions, yellow",category:"Produce"))
        putItem(Item.create(name:"Onions, white",category:"Produce"))
        putItem(Item.create(name:"Lemons",category:"Produce"))
        putItem(Item.create(name:"Oranges",category:"Produce"))
        putItem(Item.create(name:"Apples",category:"Produce"))
        putItem(Item.create(name:"Apples, Granny Smith",category:"Produce"))
        putItem(Item.create(name:"Apples, Mcintosh",category:"Produce"))
        putItem(Item.create(name:"Apples, Gala",category:"Produce"))
        putItem(Item.create(name:"Apples, Fuji",category:"Produce"))
        putItem(Item.create(name:"Apples, Braeburn",category:"Produce"))
        addCategory("Dairy")
        putItem(Item.create(name:"Milk, 2%",category:"Dairy"))
        putItem(Item.create(name:"Milk, Whole",category:"Dairy"))
        putItem(Item.create(name:"Milk, 1%",category:"Dairy"))
        putItem(Item.create(name:"Milk, Chocolate",category:"Dairy"))
        putItem(Item.create(name:"Eggs",category:"Dairy"))
        putItem(Item.create(name:"Butter",category:"Dairy"))
        putItem(Item.create(name:"Sour Cream",category:"Dairy"))
        putItem(Item.create(name:"Yogurt, Fat Free",category:"Dairy"))
        putItem(Item.create(name:"Yogurt, Reduced Fat",category:"Dairy"))
        putItem(Item.create(name:"Yogurt, Whole",category:"Dairy"))
        addCategory("Fish+Meats")
        putItem(Item.create(name:"Beef, angus",category:"Fish+Meats"))
        putItem(Item.create(name:"Chicken, thighs",category:"Fish+Meats"))
        putItem(Item.create(name:"Chicken, roasted",category:"Fish+Meats"))
        putItem(Item.create(name:"Chicken, wings",category:"Fish+Meats"))
        putItem(Item.create(name:"Pork, chops",category:"Fish+Meats"))
        putItem(Item.create(name:"Tuna",category:"Fish+Meats"))
        putItem(Item.create(name:"Salmon, pink",category:"Fish+Meats"))
        putItem(Item.create(name:"Salmon, red sockeye",category:"Fish+Meats"))
        addCategory("Drink")
        putItem(Item.create(name:"Coffee, whole beans",category:"Drink"))
        putItem(Item.create(name:"Coffee, whole beans, dark roast",category:"Drink"))
        putItem(Item.create(name:"Coffee, whole beans, light roast",category:"Drink"))
        putItem(Item.create(name:"Coffee, ground, French roast",category:"Drink"))
        putItem(Item.create(name:"Tea, green",category:"Drink"))
        putItem(Item.create(name:"Tea, peppermint, caffeine-free",category:"Drink"))
        putItem(Item.create(name:"Ginger beer",category:"Drink"))
        putItem(Item.create(name:"Cola",category:"Drink"))
        putItem(Item.create(name:"Coconut water",category:"Drink"))
        putItem(Item.create(name:"Ginger ale",category:"Drink"))
        putItem(Item.create(name:"Water, spring",category:"Drink"))
        putItem(Item.create(name:"Water, mineral",category:"Drink"))
        addCategory("Misc")
        putItem(Item.create(name:"Matches",category:"Misc"))
        putItem(Item.create(name:"Lighter",category:"Misc"))
        putItem(Item.create(name:"Lightbulb",category:"Misc"))
        putItem(Item.create(name:"Nails",category:"Misc"))
        putItem(Item.create(name:"Garbage bags",category:"Misc"))
        putItem(Item.create(name:"Toilet paper",category:"Misc"))
        putItem(Item.create(name:"Paper towels",category:"Misc"))
    }
    
}

