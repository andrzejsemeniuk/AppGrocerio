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
        case Volume         (oz:Double)
        
        var code: String {
                switch self
                {
                case Checkmark:     return "c"
                case Quantity:      return "q"
                case Weight:        return "w"
                case Volume:        return "v"
                }
        }
        
        func reset() {
            switch self {
            case var Checkmark(on):         on=false
            case var Quantity(count):       count=0
            case var Weight(pounds):        pounds=0
            case var Volume(oz):            oz=0
            }
        }
        
        static func deserialize(array:[AnyObject]) -> Value {
            switch array[0] as! String {
            case "c": return Checkmark(on:array[1] as! Bool)
            case "q": return Quantity(count:array[1] as! Int)
            case "w": return Weight(pounds:array[1] as! Double)
            case "v": return Volume(oz:array[1] as! Double)
            default: return Checkmark(on:false)
            }
        }
        
        func serialize() -> [AnyObject] {
            switch self {
            case let Checkmark(on):         return [code,on]
            case let Quantity(count):       return ["q",count]
            case let Weight(pounds):        return ["w",pounds]
            case let Volume(oz):            return ["v",oz]
            }
        }
    }
    
    let name:       String
    let category:   String
    let value:      Value
    
    func reset()
    {
        value.reset()
    }
}



class ItemsDataManager : NSObject
{
    enum Key: String {
        case Categories, Items
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
        
        all![item.name] = item.value.serialize()
        
        defaults.setObject(all!,forKey:key)
    }
    
    class func resetItem           (item:Item)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if var all = defaults.dictionaryForKey(itemsKey(item.category)) {
            all.removeValueForKey(item.name)
            item.reset()
            all[item.name] = item.value.serialize()
        }
    }
    
    class func removeItem           (item:Item)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if var all = defaults.dictionaryForKey(itemsKey(item.category)) {
            all.removeValueForKey(item.name)
        }
    }
    
    class func allItemsInCategory   (category:String, sorted:Bool = true) -> [Item]
    {
        var result:[Item] = []
        
        let defaults = NSUserDefaults.standardUserDefaults()

        if let all = defaults.dictionaryForKey(itemsKey(category)) {
            for (key,value) in all {
                if let array = value as? Array<AnyObject> {
                    result.append(Item(name:key, category:category, value:Item.Value.deserialize(array)))
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
    
    class func clearCategories      (categories:[String] = ["Produce","Meat","Drink","Sweets","Misc"])
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.removeObjectForKey(Key.Categories.rawValue)
    }

    
    class func reset(ifEmpty:Bool = true)
    {
        let categories = allCategories()
        
        // empty,0 => yes
        // empty,n => no
        // not empty,0 => yes
        // not empty,n => yes
        
        let proceed = !(ifEmpty && 0 < categories.count)
        
        if proceed
        {
            for category in categories {
                removeCategory(category)
            }
            
            addCategory("Produce")
            putItem(Item(name:"Lettuce",category:"Produce",value:.Quantity(count:0)))
            putItem(Item(name:"Cabbage",category:"Produce",value:.Quantity(count:0)))
            putItem(Item(name:"Tomatoes",category:"Produce",value:.Quantity(count:0)))
            putItem(Item(name:"Potatoes",category:"Produce",value:.Quantity(count:0)))
            putItem(Item(name:"Garlic",category:"Produce",value:.Quantity(count:0)))
            putItem(Item(name:"Yellow Onions",category:"Produce",value:.Quantity(count:0)))
            putItem(Item(name:"White Onions",category:"Produce",value:.Quantity(count:0)))
            addCategory("Dairy")
            putItem(Item(name:"Milk, 2%",category:"Dairy",value:.Quantity(count:0)))
            putItem(Item(name:"Milk, Whole",category:"Dairy",value:.Quantity(count:0)))
            putItem(Item(name:"Milk, 1%",category:"Dairy",value:.Quantity(count:0)))
            putItem(Item(name:"Milk, Chocolate",category:"Dairy",value:.Quantity(count:0)))
            putItem(Item(name:"Eggs",category:"Dairy",value:.Quantity(count:0)))
            putItem(Item(name:"Butter",category:"Dairy",value:.Quantity(count:0)))
            putItem(Item(name:"Sour Cream",category:"Dairy",value:.Quantity(count:0)))
            putItem(Item(name:"Yoghurt, Fat Free",category:"Dairy",value:.Quantity(count:0)))
            putItem(Item(name:"Yoghurt, Reduced Fat",category:"Dairy",value:.Quantity(count:0)))
            putItem(Item(name:"Yoghurt, Whole",category:"Dairy",value:.Quantity(count:0)))
            addCategory("Fish+Meats")
            addCategory("Drink")
            addCategory("Breakfast")
            addCategory("Misc")
        }
    }

}

