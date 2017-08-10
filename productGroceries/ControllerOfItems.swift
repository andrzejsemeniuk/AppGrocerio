//
//  ItemsController.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import ASToolkit




class ItemsController : UITableViewController, UIGestureRecognizerDelegate
{
    var items:[Store.Item]           = []
    
    var category:String             = ""
    
    var colorOfCategory:UIColor     = UIColor.white
    
    var lastTap:UITableViewTap!
    

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource    = self
        
        tableView.delegate      = self
        
        
        tableView.separatorStyle = .none

        
        var items = navigationItem.rightBarButtonItems
        
        if items == nil {
            items = [UIBarButtonItem]()
        }
        
        items! += [
            UIBarButtonItem(barButtonSystemItem:.add, target:self, action: #selector(ItemsController.add))
//            editButtonItem(),
        ]
        
        navigationItem.rightBarButtonItems = items
        
        
        
        // "add gesture recognizer to determine which side of cell was tapped on"
        
        let recognizer = UITapGestureRecognizer(target:self, action:#selector(ItemsController.handleTap(_:)))
        
        recognizer.delegate = self
        
        tableView.addGestureRecognizer(recognizer)
    }
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    
    class func styleCell(_ cell:UITableViewCell, item:Store.Item, indexPath:IndexPath)
    {
        var preferences                 : Preferences {
            return AppDelegate.instance.preferences
        }
        
        cell.selectedBackgroundView = UIView.createWithBackgroundColor(Store.Manager.settingsGetSelectionColor())
        
        do
        {
            var color = ControllerOfCategories.instance.colorForItem(item: item,onRow:indexPath.row)
            
            //            let rgba  = color.RGBA()
            
            let alpha = indexPath.row.isEven ? preferences.settingTabItemsRowEvenOpacity.value : preferences.settingTabItemsRowOddOpacity.value
            
            color = color.withAlphaComponent(CGFloat(alpha))
            
            cell.backgroundColor = color
        }
        
        if let label = cell.textLabel {
            
            if preferences.settingTabItemsUppercase.value {
                label.text = item.name.uppercased()
            }
            else {
                label.text = item.name
            }
            
            if preferences.settingTabItemsTextColorSameAsCategories.value {
                label.textColor = preferences.settingTabCategoriesTextColor.value
            }
            else {
                label.textColor = preferences.settingTabItemsTextColor.value
            }
            

            if preferences.settingTabItemsFontSameAsCategories.value {
                // TODO: REFACTOR
                let defaultFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
                label.font      = UIFont(name:preferences.settingTabCategoriesFont.value,
                                         size:defaultFont.pointSize + preferences.settingTabCategoriesFontGrowth.value)
                    ?? defaultFont
            }
            else {
                // TODO: REFACTOR
                let defaultFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
                label.font      = UIFont(name:preferences.settingTabItemsFont.value,
                                         size:defaultFont.pointSize + preferences.settingTabItemsFontGrowth.value)
                    ?? defaultFont
            }

            if preferences.settingTabItemsEmphasize.value {
                label.font = label.font.withSize(label.font.pointSize+1)
            }
        }
        
        cell.selectionStyle = .default
    }

    
    
    
    
    override func numberOfSections              (in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView                     (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    override func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let item = items[indexPath.row]
        
        let cell = UITableViewCell(style:.default,reuseIdentifier:nil)
        
        ItemsController.styleCell(cell,item:item,indexPath:indexPath)
        
        if 0 < item.quantity
        {
            _ = ControllerOfCategories.instance.styleQuantity(cell:cell,indexPath:indexPath,quantity:item.quantity)
        }
        
        return cell
    }
    
    
    
    
    func reload()
    {
        items = Store.Manager.itemGetAllInCategory(category)
        
        self.title = category

        tableView.reloadData()
    }
    
    
    
    func add()
    {
        let alert = UIAlertController(title:"Add a new item", message:"Specify new item name:", preferredStyle:.alert)
        
        alert.addTextField() {
            field in
            // called to configure text field before displayed
        }
        
        let actionAdd = UIAlertAction(title:"Add", style:.default, handler: {
            action in
            
            if let fields = alert.textFields, let text = fields[0].text {
                Store.Manager.itemPut(Store.Item.create(name:text.trimmed(),category:self.category))
                self.reload()
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        switch editingStyle
        {
        case .none:
            print("None")
        case .delete:
            let item = items[indexPath.row]
            Store.Manager.itemRemove(item)
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with:.left)
        case .insert:
            add()
        }
    }
    
    
    
    
    
    var player:AVAudioPlayer?

    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var item = items[indexPath.row]
        
        if lastTap.path == indexPath {
            var update = false
            
            if lastTap.point.x < tableView.bounds.width * 0.3 {
                if 0 < item.quantity {
                    _ = Audio.playItemDecrement()

                    item.quantity -= 1
                    
                    update = true
                }
            }
            else if lastTap.point.x > tableView.bounds.width * 0.7 {
                _ = Audio.playItemIncrement()
                
                item.quantity += 1
                
                update = true
            }
            
            if update {
                Store.Manager.itemPut(item)
                items[indexPath.row] = item
                self.reload()
            }
        }
    }

    
    
    
    func scrollToItem(_ name:String,select:Bool = true)
    {
        var row = -1
        
        for (index,item) in items.enumerated() {
            if item.name == name {
                row = index
                break
            }
        }
        
        if 0 <= row {
            let path = IndexPath(row:row,section:0)
            
//            tableView.scrollToRowAtIndexPath(path,atScrollPosition:.Middle,animated:true)
            tableView.selectRow(at: path,animated:true,scrollPosition:.middle)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        reload()

        
        tableView.backgroundColor = AppDelegate.instance.preferences.settingBackgroundColor.value
        

        Store.Manager.displayHelpPageForItems(self)

        super.viewWillAppear(animated)
    }
    

    
    
    
    func gestureRecognizerShouldBegin(_ recognizer: UIGestureRecognizer) -> Bool
    {
        let point = recognizer.location(in: tableView)
        
        if let path = tableView.indexPathForRow(at: point)
        {
            lastTap = UITableViewTap(path:path, point:point)
        }
        
        return false
    }
    
    
    

    func handleTap(_ recognizer:UIGestureRecognizer)
    {
        // unused - we're not interested
    }
    
 
    
}
