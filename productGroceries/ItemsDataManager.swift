//
//  ItemsData.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation

struct Item
{
    enum Value
    {
        case Checkmark      (on:Bool)
        case Quantity       (count:Int)
        case Weight         (pounds:Double)
        case Volume         (oz:Float)
        
        var code: Character {
                switch self
                {
                case Checkmark:     return "c"
                case Quantity:      return "q"
                case Weight:        return "w"
                case Volume:        return "v"
                }
        }
    }
    
    let name:       String
    let category:   String
    let value:      Value
}



class ItemsDataManager : NSObject
{
    enum Key: String {
        case Categories, Items
    }
    
    class func putItem              (item:Item)
    {
        
    }
    
    class func clearItem            (item:Item)
    {
        
    }
    
    class func removeItem           (item:Item)
    {
        
    }
    
    class func allItemsInCategory   (category:String, sorted:Bool = true) -> [Item]
    {
        return []
    }
    
    class func allItems             () -> [Item]
    {
        return []
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
    
    class func clearCategory        (category:String)
    {
        
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
                // TODO REMOVE ALL ITEMS IN CATEGORY AS WELL
                result = true
            }
        }
        
        return result
    }
    
    class func allCategories        (fresh:[String] = ["Produce","Meat","Drink","Sweets","Misc"]) -> [String]
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var result = [String]()
        
        if let categories = defaults.arrayForKey(Key.Categories.rawValue) {
            for category in categories {
                result.append(category as! String)
            }
        }
        else {
            result = fresh
            defaults.setObject(result, forKey:Key.Categories.rawValue)
        }
        
        return result.sort { return $0 < $1 }
    }
    
    class func clearCategories      (categories:[String] = ["Produce","Meat","Drink","Sweets","Misc"])
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.removeObjectForKey(Key.Categories.rawValue)
    }

}

