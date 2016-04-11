//
//  ControllerOfSummary.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/9/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

class ControllerOfSummary : UITableViewController, UIPopoverPresentationControllerDelegate
{
    var items:[[Data.Item]] = [[]]
    
    var lastTap:UITableViewTap!
    
    var buttonLoad:UIBarButtonItem!
    
    
    override func viewDidLoad()
    {
        tableView.dataSource    = self
        
        tableView.delegate      = self
        
        tableView.separatorStyle = .None

        
        
        
        do
        {
            var items = navigationItem.leftBarButtonItems
            
            if items == nil {
                items = [UIBarButtonItem]()
            }
            
            buttonLoad = UIBarButtonItem(title:"Load", style:.Plain, target:self, action: #selector(ControllerOfSummary.load))
            
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
                UIBarButtonItem(barButtonSystemItem:.Save, target:self, action: "save"),
            ]
            
            navigationItem.rightBarButtonItems = items
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
    
    
    
    func save()
    {
        let alert = UIAlertController(title:"Save Grocery List", message:"Specify name of grocery list:", preferredStyle:.Alert)
        
        alert.addTextFieldWithConfigurationHandler() {
            field in
            // called to configure text field before displayed
            if self.lastGroceryListName != nil {
                field.text = self.lastGroceryListName!
            }
            else {
                field.text = ""
            }
        }
        
        let actionSave = UIAlertAction(title:"Save", style:.Default, handler: {
            action in
            
            if let fields = alert.textFields, text = fields[0].text?.trimmed() {
                if text != "Clear" {
                    if Data.Manager.summarySave(text) {
                        self.lastGroceryListName = text
                    }
                }
            }
        })
        
        let actionCancel = UIAlertAction(title:"Cancel", style:.Cancel, handler: {
            action in
        })
        
        alert.addAction(actionSave)
        alert.addAction(actionCancel)
        
        AppDelegate.rootViewController.presentViewController(alert, animated:true, completion: {
            print("completed showing add alert")
        })
    }

    
    func load()
    {
        
        let list = GenericControllerOfList()
        
        list.items                      = ["Clear"] + Data.Manager.summaryList()
        list.items = list.items.sort()
        
//        list.tableView.separatorStyle   = .SingleLineEtched

        list.handlerForDidSelectRowAtIndexPath = { (controller:GenericControllerOfList,indexPath:NSIndexPath) -> Void in
            let row         = indexPath.row
            let selection   = list.items[row]
            if selection == "Clear" {
                Data.Manager.summaryClear()
            }
            else {
                Data.Manager.summaryUse(selection)
            }
//            controller.dismissViewControllerAnimated(true, completion:nil)
            controller.navigationController!.popViewControllerAnimated(true)
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

    
    
    
    func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController)
    {
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller:UIPresentationController) -> UIModalPresentationStyle
    {
        return .Popover
    }
    
    
    
    override func numberOfSectionsInTableView   (tableView: UITableView) -> Int
    {
        return items.count
    }
    
    override func tableView                     (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items[section].count
    }
    
    override func tableView                     (tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let result                  = UILabel()
        
        let text                    = items[section][0].category
        
        if Data.Manager.settingsGetBoolForKey(.SettingsTabCategoriesUppercase) {
            result.text                 = text.uppercaseString
        }
        else {
            result.text                 = text
        }

        result.textColor            = Data.Manager.settingsGetCategoriesTextColor()
        result.font                 = Data.Manager.settingsGetCategoriesFont()

        if Data.Manager.settingsGetBoolForKey(.SettingsTabCategoriesEmphasize) {
            result.font = result.font.fontWithSize(result.font.pointSize+2)
        }
        

        result.textAlignment        = .Center
//        result.font                 = UIFont.systemFontOfSize(12, weight:2.0)
        result.backgroundColor      = ControllerOfCategories.instance.colorForCategory(text)
//        result.textColor            = UIColor.whiteColor()
        
        return result
    }
    
    override func tableView                     (tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }
    
    override func tableView                     (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let item = items[indexPath.section][indexPath.row]
        
        let cell = UITableViewCell(style:.Default,reuseIdentifier:nil)
        
        ItemsController.styleCell(cell,item:item,indexPath:indexPath)

        cell.selectionStyle = .None

        let views = ControllerOfCategories.instance.styleQuantity(cell,indexPath:indexPath,quantity:item.quantity)
        
        return cell
    }
    
    
    
    
    func reload(updateTable:Bool = true)
    {
        items = Data.Manager.summary()

        if updateTable {
            tableView.reloadData()
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool)
    {
        reload(true)
        
        
        tableView.backgroundColor = Data.Manager.settingsGetBackgroundColor()

        
        Data.Manager.displayHelpPageForSummary(self)

        super.viewWillAppear(animated)
    }

    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            let section     = indexPath.section
            let row         = indexPath.row
            let item        = items[section][row]
            Data.Manager.resetItem(item)
            items[section].removeAtIndex(row)
            if items[section].count < 1 {
                items.removeAtIndex(section)
            }
            reload(true)

        }
    }
    
    
    
}
