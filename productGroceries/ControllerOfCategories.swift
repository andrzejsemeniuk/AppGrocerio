//
//  ControllerOfCategories.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit
import ASToolkit

class ControllerOfCategories : UITableViewController {
    
    var preferences                 : Preferences {
        return AppDelegate.instance.preferences
    }

    var categories                  : [String]      = []
    var quantities                  : [Int]         = []
    
    
    static var instance:ControllerOfCategories! = nil
    
    
    override func viewDidLoad()
    {
        ControllerOfCategories.instance = self
        
        super.viewDidLoad()
        
        self.title                  = "Categories"
        
        tableView.dataSource        = self
        
        tableView.delegate          = self
        
        tableView.autoresizingMask  = [.flexibleHeight, .flexibleWidth]
        
        tableView.separatorStyle = .none

        
        
        
        // TODO CREATE REUSABLE CELL
        
        
        
        do
        {
            var items = navigationItem.rightBarButtonItems
            
            if items == nil {
                items = [UIBarButtonItem]()
            }
            
            items! += [
                UIBarButtonItem(barButtonSystemItem:.add, target:self, action: #selector(ControllerOfCategories.add)),
            ]

            navigationItem.rightBarButtonItems = items
        }

        
        
        
        reload()
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
        let saturation = preferences.settingTabThemesSaturation.value
        
        let mark:CGFloat = CGFloat(Float(index)/Float(categories.count)).clampedTo01
        
        switch preferences.settingCurrent.value
        {
        case "Apple":
            return UIColor(hue:mark.lerp01(from:0.15, to:0.35), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Charcoal":
            return index.isEven ? UIColor(white:0.2,alpha:1.0) : UIColor(white:0.17,alpha:1.0)
        case "Grape":
            return UIColor(hue:mark.lerp01(from:0.75, to:0.90), saturation:saturation, brightness:mark.lerp01(from:0.65, to:0.80), alpha:1.0)
        case "Gray":
            return UIColor(white:0.4, alpha:1.0)
        case "Orange":
            return UIColor(hue:mark.lerp01(from:0.04, to:0.1), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Plain":
            return UIColor.white
        case "Rainbow":
            return UIColor(hue:mark.lerp01(from:0.0, to:0.9), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Range":
            let color0  = preferences.settingTabThemesRangeFromColor.value.HSBA
            let color1  = preferences.settingTabThemesRangeToColor.value.HSBA
            return UIColor(hue:mark.lerp01(from:color0.hue, to:color1.hue),
                           saturation:mark.lerp01(from:color0.saturation, to:color1.saturation)*saturation,
                           brightness:mark.lerp01(from:color0.brightness, to:color1.brightness),
                           alpha:1.0)
        case "Strawberry":
            return UIColor(hue:mark.lerp01(from:0.89, to:0.99), saturation:saturation, brightness:1.0, alpha:1.0)
        case "Solid":
            let HSBA = preferences.settingTabThemesSolidColor.value.HSBA
            return UIColor(hue:CGFloat(HSBA.hue), saturation:HSBA.saturation*saturation, brightness:CGFloat(HSBA.brightness), alpha:1.0)
        default:
            break
        }

        return UIColor.white
    }
    
    
    func colorForCategory(category:String) -> UIColor
    {
        if let index = categories.index(of: category) {
            return colorForCategoryIndex(index: index)
        }
        else {
            return colorForCategoryIndex(index: -1)
        }
    }
    
    
    func colorForItem(item:Store.Item, onRow:Int) -> UIColor {
        let categoryColor = colorForCategory(category: item.category)
            
        let HSBA = categoryColor.HSBA
        
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
            let brightness1 = HSBA.brightness < 1.0 ? (HSBA.brightness+0.05).clampedTo01 : (HSBA.brightness-0.05).clampedTo01
            return UIColor(hue:HSBA.hue,saturation:0.0,brightness:brightness1,alpha:1.0)
        }

    }
    
    func styleCell(cell:UITableViewCell, indexPath:IndexPath)
    {
        cell.selectedBackgroundView = UIView.createWithBackgroundColor(Store.Manager.settingsGetSelectionColor())

        cell.backgroundColor        = colorForCategoryIndex(index: indexPath.row)
        
        print("styleCell: indexPath.row=\(indexPath.row), section=\(indexPath.section)")
        
        if let label = cell.textLabel {
            
            if preferences.settingTabCategoriesUppercase.value {
                label.text = categories[indexPath.row].uppercased()
            }
            else {
                label.text = categories[indexPath.row]
            }
            
            label.textColor = preferences.settingTabCategoriesTextColor.value
            
            // TODO: REFACTOR
            let defaultFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
            label.font      = UIFont(name:preferences.settingTabCategoriesFont.value,
                                     size:defaultFont.pointSize + preferences.settingTabCategoriesFontGrowth.value)
                ?? defaultFont
            
            if preferences.settingTabCategoriesEmphasize.value {
                label.font = label.font.withSize(label.font.pointSize+2)
            }
            
            var white:CGFloat = 0
            var alpha:CGFloat = 1
            
            cell.backgroundColor!.getWhite(&white,alpha:&alpha)
            
            // TODO PREFERENCES: LIGHT/DARK COLOR
            //            label.textColor = white < 0.5 ? UIColor.lightTextColor() : UIColor.darkTextColor()
        }
        
        cell.selectionStyle     = UITableViewCellSelectionStyle.default
        
        cell.accessoryType      = .none//.DisclosureIndicator        
    }
    
    func styleQuantity(cell:UITableViewCell,indexPath:IndexPath,quantity:Int) -> (fill:UIView,label:UILabel)
    {
        
        let fill = UIView()
        
        fill.frame                  = CGRect(x:0,y:0,width:cell.bounds.height*1.2,height:cell.bounds.height)
        fill.frame.origin.x         = AppDelegate.rootViewController.view.bounds.width-fill.frame.size.width
        fill.backgroundColor        = preferences.settingTabItemsQuantityColorBackground.value.withAlphaComponent(preferences.settingTabItemsQuantityColorBackgroundOpacity.value)
        
        cell.addSubview(fill)
        
        
        let label = UILabel()
        
        label.frame                 = CGRect(x:0,y:0,width:cell.bounds.height*2,height:cell.bounds.height)
        
        // TODO: REFACTOR
        let defaultFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        label.font      = UIFont(name:preferences.settingTabItemsQuantityFont.value,
                                 size:defaultFont.pointSize + preferences.settingTabItemsQuantityFontGrowth.value)
            ?? defaultFont

        // TODO: REFACTOR
        if preferences.settingTabItemsQuantityColorTextSameAsItems.value {
            label.textColor         = preferences.settingTabItemsTextColor.value
        }
        else {
            label.textColor         = preferences.settingTabItemsQuantityColorText.value
        }
        label.text                  = String(quantity)
        label.textAlignment         = .right
        
        cell.accessoryView          = label
        cell.editingAccessoryView   = label
        
        return (fill,label)
    }
    
    
    override func numberOfSections              (in: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView                     (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    override func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style:.default,reuseIdentifier:nil)
        
        styleCell(cell: cell,indexPath:indexPath)
        
        if 0 < quantities[indexPath.row]
        {
            _ = ControllerOfCategories.instance.styleQuantity(cell: cell,indexPath:indexPath,quantity:quantities[indexPath.row])
        }
        
        return cell
    }

    
    
    
    
    func reload()
    {
        categories = Store.Manager.categoryGetAll()
        
        quantities = []
        
        for category in categories
        {
            let items = Store.Manager.itemGetAllInCategory(category)
            var count = 0
            for item in items {
                if 0 < item.quantity {
                    count += 1
                }
            }
            quantities += [ count ]
        }

        tableView.reloadData()
    }
    
    
    
    // NOTE: THIS METHOD IS REFERENCED IN APPDELEGTE 
    
    func add()
    {
        let alert = UIAlertController(title:"Add a new Category", message:"Specify new category name:", preferredStyle:.alert)
        
        alert.addTextField() {
            field in
        }
        
        let actionAdd = UIAlertAction(title:"Add", style:.default, handler: {
            action in
            
            if let fields = alert.textFields, let text = fields[0].text {
                if Store.Manager.categoryAdd(text) {
                    self.reload()
                }
            }
        })
        
        let actionCancel = UIAlertAction(title:"Cancel", style:.cancel, handler: {
            action in
        })
        
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        
        AppDelegate.rootViewController.present(alert, animated:true, completion: {
            print("completed showing add alert")
        })
    }
    
    
    
    // NOTE: THIS IS A TABLE-DATA-SOURCE-DELEGATE METHOD
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle
        {
        case .none:
            print("None")
        case .delete:
            let category = categories[indexPath.row]
            _ = Store.Manager.categoryRemove(category)
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with:.left)
            self.reload()
        case .insert:
            add()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        _ = openItemsForRow(row: indexPath.row)
    }


    func openItemsForRow(row:Int) -> ItemsController
    {
        let category    = categories[row]
        
        let items       = ItemsController()
        
        items.colorOfCategory = colorForCategoryIndex(index: row)
        
        items.category  = category
        items.items     = Store.Manager.itemGetAllInCategory(category)
        
        AppDelegate.navigatorForCategories.pushViewController(items, animated:true)
        
        return items
    }

    func openItemsForCategory(category:String,name:String? = nil)
    {
        if let index = categories.index(of: category) {
            let items = openItemsForRow(row: index)
            
            if let item = name {
                items.scrollToItem(item,select:true)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        reload()

        
        tableView.backgroundColor = preferences.settingBackgroundColor.value

        
        Store.Manager.displayHelpPageForCategories(self)
        
        super.viewWillAppear(animated)
    }
    
    
    

}


