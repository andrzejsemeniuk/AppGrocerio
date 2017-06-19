//
//  ControllerOfSummary.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit
import TGF


class ControllerOfSummary : UITableViewController, UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate
{
    var items:[[Data.Item]] = [[]]
    
    var lastTap:UITableViewTap!
    
    var buttonLoad:UIBarButtonItem!
    
    
    
    
    override func viewDidLoad()
    {
        tableView.dataSource    = self
        
        tableView.delegate      = self
        
        tableView.separatorStyle = .none

        
        
        
        do
        {
            var items = navigationItem.leftBarButtonItems
            
            if items == nil {
                items = [UIBarButtonItem]()
            }
            
            buttonLoad = UIBarButtonItem(title:"Add", style:.plain, target:self, action: #selector(ControllerOfSummary.add))
            
            items! += [
                buttonLoad
            ]
            
            navigationItem.leftBarButtonItems = items
        }

        
        
        
        do
        {
            var items = navigationItem.rightBarButtonItems
            
            if items == nil {
                items = [UIBarButtonItem]()
            }
            
            items! += [
                UIBarButtonItem(barButtonSystemItem:.save, target:self, action: #selector(ControllerOfSummary.save))
            ]
            
            navigationItem.rightBarButtonItems = items
        }

        
        
        
        do
        {
            // "add gesture recognizer to determine which side of cell was tapped on"
            
            let recognizer = UITapGestureRecognizer(target:self, action:#selector(ItemsController.handleTap(_:)))
            
            recognizer.delegate = self
            
            tableView.addGestureRecognizer(recognizer)
        }

        
        
        
        
        reload(false)
        
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        // TODO clear data and reload table
    }
    
    
    
    
    var lastGroceryListName:String?
    
    
    let CLEAR   = "<< Clear >>"
    

    func save()
    {
        let alert = UIAlertController(title:"Save Grocery List", message:"Specify name of grocery list:", preferredStyle:.alert)
        
        alert.addTextField() {
            field in
            // called to configure text field before displayed
            if self.lastGroceryListName != nil {
                field.text = self.lastGroceryListName!
            }
            else {
                field.text = ""
            }
        }
        
        let actionSave = UIAlertAction(title:"Save", style:.default, handler: {
            action in
            
            if let fields = alert.textFields, let text = fields[0].text?.trimmed() {
                if text != self.CLEAR {
                    if Data.Manager.summarySave(text) {
                        self.lastGroceryListName = text
                    }
                }
            }
        })
        
        let actionCancel = UIAlertAction(title:"Cancel", style:.cancel, handler: {
            action in
        })
        
        alert.addAction(actionSave)
        alert.addAction(actionCancel)
        
        AppDelegate.rootViewController.present(alert, animated:true, completion: {
            print("completed showing add alert")
        })
    }

    
    
    
    
    func add()
    {
        let list    = GenericControllerOfList()
        
        list.items  = [CLEAR] + Data.Manager.summaryList()
        list.items  = list.items.sorted()
        
//        list.tableView.separatorStyle   = .SingleLineEtched

        list.handlerForDidSelectRowAtIndexPath = { controller, indexPath in
            let row         = indexPath.row
            let selection   = list.items[row]
            if selection == self.CLEAR {
                Data.Manager.summaryClear()
            }
            else {
                _ = Data.Manager.summaryAdd(selection)
            }
//            controller.dismissViewControllerAnimated(true, completion:nil)
            controller.navigationController!.popViewController(animated: true)
        }

        self.navigationController!.pushViewController(list,animated:true)
        
//        let list = GenericListController()
//        
//        list.items                          = ["Clear",""] + Data.Manager.summaryList()
//        list.modalPresentationStyle         = UIModalPresentationStyle.Popover
//        list.preferredContentSize           = CGSizeMake(400, 400)
////        list.tableView.frame = CGRectMake(0,0,200,200)
//
//        self.presentViewController(list, animated: true, completion: nil)
//
//        let popover = list.popoverPresentationController
////        popover?.delegate                   = self
//        popover?.barButtonItem              = buttonLoad
//        popover?.popoverLayoutMargins       = UIEdgeInsetsMake(60,60,60,60)

//        list.handlerForDidSelectRowAtIndexPath = { (controller:GenericListController,indexPath:NSIndexPath) -> Void in
//            let row         = indexPath.row
//            let selection   = list.items[row]
//            if selection == "Clear" {
//                Data.Manager.summaryClear()
//            }
//            else {
//                Data.Manager.summaryUse(selection)
//            }
//            controller.dismissViewControllerAnimated(true, completion:nil)
//        }

    }

    
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController)
    {
        
    }
    
    func adaptivePresentationStyle(for controller:UIPresentationController) -> UIModalPresentationStyle
    {
        return .popover
    }
    
    
    
    override func numberOfSections   (in tableView: UITableView) -> Int
    {
        return items.count
    }
    
    override func tableView                     (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items[section].count
    }
    
    override func tableView                     (_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let result                  = UILabel()
        
        let text                    = items[section][0].category
        
        if Data.Manager.settingsGetBoolForKey(.SettingsTabCategoriesUppercase) {
            result.text                 = text.uppercased()
        }
        else {
            result.text                 = text
        }

        result.textColor            = Data.Manager.settingsGetCategoriesTextColor()
        result.font                 = Data.Manager.settingsGetCategoriesFont()

        if Data.Manager.settingsGetBoolForKey(.SettingsTabCategoriesEmphasize) {
            result.font = result.font.withSize(result.font.pointSize+2)
        }
        

        result.textAlignment        = .center
//        result.font                 = UIFont.systemFontOfSize(12, weight:2.0)
        result.backgroundColor      = ControllerOfCategories.instance.colorForCategory(category: text)
//        result.textColor            = UIColor.whiteColor()
        
        return result
    }
    
    override func tableView                     (_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }
    
    override func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let item = items[indexPath.section][indexPath.row]
        
        let cell = UITableViewCell(style:.default,reuseIdentifier:nil)
        
        ItemsController.styleCell(cell,item:item,indexPath:indexPath)

        cell.selectionStyle = .none

        if let label = cell.textLabel
        {
            if item.quantity == -1
            {
                let s = NSMutableAttributedString(string:label.text!)
                
                let range = NSRange(location:0,length:s.string.characters.distance(from: s.string.startIndex, to: s.string.endIndex))
                
                s.addAttribute(NSStrikethroughStyleAttributeName,
                               value:2,
                               range:range)
                
                label.attributedText = s;
                
//                label.text = nil
            }
            else
            {
                _ = ControllerOfCategories.instance.styleQuantity(cell: cell,indexPath:indexPath,quantity:item.quantity)
            }
        }

        return cell
    }
    
    
    
    
    func reload(_ updateTable:Bool = true)
    {
        items = Data.Manager.summary()

        if updateTable {
            tableView.reloadData()
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        reload(true)
        
        
        tableView.backgroundColor = Data.Manager.settingsGetBackgroundColor()

        
        Data.Manager.displayHelpPageForSummary(self)

        super.viewWillAppear(animated)
    }

    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            let section     = indexPath.section
            let row         = indexPath.row
            let item        = items[section][row]
            Data.Manager.itemReset(item)
            items[section].remove(at: row)
            if items[section].count < 1 {
                items.remove(at: section)
            }
            reload(true)

        }
    }
    
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let section     = indexPath.section
        let row         = indexPath.row
        var item        = items[section][row]
        
        if lastTap.path == indexPath {
            var update = false
            
            if lastTap.point.x < tableView.bounds.width*0.3 {
                
                if item.quantity == -1 {
                    _ = Audio.playItemDisappear()
                    item.quantity = 0
                }
                else if 1 < item.quantity {
                    _ = Audio.playItemDecrement()
                    item.quantity -= 1
                }
                else {
                    _ = Audio.playItemCrossOut()
                    item.quantity = -1
                }
                
                update = true
            }
            else if lastTap.point.x > tableView.bounds.width*0.7 {
                
                _ = Audio.playItemIncrement()

                if item.quantity == -1 {
                    item.quantity = 1
                }
                else {
                    item.quantity += 1
                }
                
                update = true
            }
            else {
//                self.player = Audio.play("Beep short 07.mp3")
                
                AppDelegate.tabBarController.selectedIndex = 0
                
                if let categories = AppDelegate.navigatorForCategories.viewControllers[0] as? ControllerOfCategories {
                    AppDelegate.navigatorForCategories.popToRootViewController(animated: false)
                    categories.openItemsForCategory(category: item.category,name:item.name)
                }
            }
            
            if update {
                Data.Manager.itemPut(item)
                if item.quantity == 0 {
                    items[section].remove(at: row)
                    if items[section].count < 1 {
                        items.remove(at: section)
                    }
                }
                else {
                    items[section][row] = item
                }
                self.reload()
            }
        }
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
