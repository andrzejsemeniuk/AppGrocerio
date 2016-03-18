//
//  CategoriesController.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class CategoriesController : UITableViewController {
    
    var categories:[String] = []
    
    
    static var instance:CategoriesController! = nil
    
    
    override func viewDidLoad()
    {
        CategoriesController.instance = self
        
        super.viewDidLoad()
        
        self.title                  = "Categories"
        
        tableView.dataSource        = self
        
        tableView.delegate          = self
        
        tableView.autoresizingMask  = [.FlexibleHeight, .FlexibleWidth]
        
        tableView.separatorStyle = .None

        // TODO CREATE REUSABLE CELL
        
        var items = navigationItem.rightBarButtonItems
        
        if items == nil {
            items = [UIBarButtonItem]()
        }
        
        items! += [
            UIBarButtonItem(barButtonSystemItem:.Add, target:self, action: "add"),
//            editButtonItem(),
        ]
        
        navigationItem.rightBarButtonItems = items

        
        categories                  = DataManager.allCategories()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        // categories = []
        // tableView.reloadData()
    }
    

    
    
    class func settingsGetThemeColorForRow(row:Int,count:Int,defaultColor:UIColor) -> UIColor
    {
        //        switch settingsGetThemeType()
        //        {
        //        case .SettingsTabThemesTypeName:
        //            switch settingsGetThemeName()
        //            {
        //                case "Apple": return UIColor.lerp(UIColor.yellowColor(),UIColor.greenColor(),Float(row)/Float(count-1))
        //            case "Apple": return UIColor.lerp(UIColor.yellowColor(),UIColor.greenColor(),Float(row)/Float(count-1))
        //            case "Apple": return UIColor.lerp(UIColor.yellowColor(),UIColor.greenColor(),Float(row)/Float(count-1))
        //            case "Strawberry": return UIColor.lerp(UIColor.yellowColor(),UIColor.greenColor(),Float(row)/Float(count-1))
        //            }
        //        case .SettingsTabThemesTypeSolid:
        //        case .SettingsTabThemesTypeRange:
        //        default:
        //            return defaultColor
        //        }
        return defaultColor
    }

    func colorForCategoryIndex(index:Int) -> UIColor
    {
        let saturation = CGFloat(DataManager.settingsGetFloatForKey(.SettingsTabThemesSaturation, defaultValue:0.4))
        
        let mark:CGFloat = CGFloat(Float(index)/Float(categories.count)).clamp01()
        
        switch DataManager.settingsGetThemeName()
        {
        case "Apple":
            return UIColor(hue:mark.lerp01(0.15,0.35), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Charcoal":
            return index.isEven ? UIColor(white:0.2,alpha:1.0) : UIColor(white:0.17,alpha:1.0)
        case "Grape":
            return UIColor(hue:mark.lerp01(0.75,0.90), saturation:saturation, brightness:mark.lerp01(0.65,0.80), alpha:1.0)
        case "Gray":
            return UIColor(white:0.4,alpha:1.0)
        case "Orange":
            return UIColor(hue:mark.lerp01(0.04,0.1), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Plain":
            return UIColor.whiteColor()
        case "Rainbow":
            return UIColor(hue:mark.lerp01(0.0,0.9), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Range":
            let hue0 = DataManager.settingsGetColorForKey(.SettingsTabThemesRangeFromColor).HSBA().hue
            let hue1 = DataManager.settingsGetColorForKey(.SettingsTabThemesRangeToColor).HSBA().hue
            return UIColor(hue:mark.lerp01(hue0,hue1), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Strawberry":
            return UIColor(hue:mark.lerp01(0.89,0.99), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Solid":
            let HSBA = DataManager.settingsGetColorForKey(.SettingsTabThemesSolidColor).HSBA()
            return UIColor(hue:CGFloat(HSBA.hue), saturation:saturation, brightness:CGFloat(HSBA.brightness), alpha:1.0)
        default:
            break
        }
        return UIColor.whiteColor()
    }
    
    
    func colorForCategory(category:String) -> UIColor
    {
        if let index = categories.indexOf(category) {
            return colorForCategoryIndex(index)
        }
        else {
            return colorForCategoryIndex(-1)
        }
    }
    
    
    func colorForItem(item:Item,onRow:Int) -> UIColor {
        let categoryColor = colorForCategory(item.category)
            
        let HSBA = categoryColor.HSBA()
        
        if 0 < HSBA.saturation {
            if onRow.isOdd {
                return UIColor(hue:HSBA.hue,saturation:0.10,brightness:1.0,alpha:1.0)
            }
            else {
                return UIColor(hue:HSBA.hue,saturation:0.15,brightness:1.0,alpha:1.0)
            }
        }
        
        if onRow.isOdd {
            return UIColor(hue:HSBA.hue,saturation:0.0,brightness:HSBA.brightness,alpha:1.0)
        }
        else {
            let brightness1 = HSBA.brightness < 1.0 ? (HSBA.brightness+0.05).clamp01() : (HSBA.brightness-0.05).clamp01()
            return UIColor(hue:HSBA.hue,saturation:0.0,brightness:brightness1,alpha:1.0)
        }

    }
    
    func styleCell(cell:UITableViewCell,indexPath:NSIndexPath)
    {
        // TODO PREFERENCES: SATURATION
        cell.backgroundColor    = colorForCategoryIndex(indexPath.row)
        
        print("styleCell: indexPath.row=\(indexPath.row), section=\(indexPath.section)")
        if let label = cell.textLabel {
            
            if DataManager.settingsGetBoolForKey(.SettingsTabCategoriesUppercase) {
                label.text = categories[indexPath.row].uppercaseString
            }
            else {
                label.text = categories[indexPath.row]
            }
            
            label.textColor = DataManager.settingsGetCategoriesTextColor()
            label.font      = DataManager.settingsGetCategoriesFont()
            
            if DataManager.settingsGetBoolForKey(.SettingsTabCategoriesEmphasize) {
                label.font = label.font.fontWithSize(label.font.pointSize+2)
            }
            
            var white:CGFloat = 0
            var alpha:CGFloat = 1
            
            cell.backgroundColor!.getWhite(&white,alpha:&alpha)
            
            // TODO PREFERENCES: LIGHT/DARK COLOR
            //            label.textColor = white < 0.5 ? UIColor.lightTextColor() : UIColor.darkTextColor()
        }
        
        cell.selectionStyle     = UITableViewCellSelectionStyle.Default
        
        cell.accessoryType      = .None//.DisclosureIndicator        
    }
    
    
    override func numberOfSectionsInTableView   (tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView                     (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    override func tableView                     (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style:.Default,reuseIdentifier:nil)
        
        styleCell(cell,indexPath:indexPath)
        
        return cell
    }

    
    
    
    
    func reload()
    {
        categories = DataManager.allCategories()
        
        tableView.reloadData()
    }
    
    
    
    // NOTE: THIS METHOD IS REFERENCED IN APPDELEGTE 
    
    func add()
    {
        let alert = UIAlertController(title:"Add a new Category", message:"Specify new category name:", preferredStyle:.Alert)
        
        alert.addTextFieldWithConfigurationHandler() {
            field in
        }
        
        let actionAdd = UIAlertAction(title:"Add", style:.Default, handler: {
            action in
            
            if let fields = alert.textFields, text = fields[0].text {
                if DataManager.addCategory(text) {
                    self.reload()
                }
            }
        })
        
        let actionCancel = UIAlertAction(title:"Cancel", style:.Cancel, handler: {
            action in
        })
        
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        
        AppDelegate.rootViewController.presentViewController(alert, animated:true, completion: {
            print("completed showing add alert")
        })
    }
    
    
    // NOTE: THIS IS A TABLE-DATA-SOURCE-DELEGATE METHOD
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        switch editingStyle
        {
        case .None:
            print("None")
        case .Delete:
            let category = categories[indexPath.row]
            DataManager.removeCategory(category)
            categories.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Left)
            self.reload()
        case .Insert:
            add()
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let category = categories[indexPath.row]
        
        let items = ItemsController()
        
        items.colorOfCategory = colorForCategoryIndex(indexPath.row)
        
//        self.navigationBar.barTintColor = [UIColor blueColor];
//        self.navigationBar.tintColor = [UIColor whiteColor];
//        self.navigationBar.translucent = NO;
        
        items.category  = category
        items.items     = DataManager.allItemsInCategory(category)
        
        AppDelegate.navigatorForCategories.pushViewController(items, animated:true)
    }

    
    
    override func viewWillAppear(animated: Bool)
    {
        tableView.reloadData()

        
        tableView.backgroundColor = DataManager.settingsGetBackgroundColor()

        
        DataManager.displayHelpPageForCategories(self)
        
        super.viewWillAppear(animated)
    }
    
    
    

}


