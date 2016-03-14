//
//  AppDelegate.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/4/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private static var __navigator:UINavigationController?
    
    private static var __instance:AppDelegate?
    
    class var instance:AppDelegate {
        return __instance!
    }
    
    class var navigator:UINavigationController {
        return __navigator!
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        AppDelegate.__instance      = self
        
//        ItemsDataManager.reset(false)
        
        // a window displays views and distributes events
        window                      = UIWindow()
        
        let WINDOW                  = window!
        
        WINDOW.screen               = UIScreen.mainScreen()
        WINDOW.bounds               = WINDOW.screen.bounds
        WINDOW.windowLevel          = UIWindowLevelNormal
        
        ItemsDataManager.reset(true)
        
        
        
        let categories              = CategoriesController()
        
        let CATEGORIES              = UINavigationController(rootViewController:categories)
        
        AppDelegate.__navigator     = CATEGORIES
        
        CATEGORIES.tabBarItem       = UITabBarItem(title:"Items", image:nil, tag:1)
        
        CATEGORIES.setNavigationBarHidden(false, animated:true)
        
        
        
        let summary                 = SummaryController()

        let SUMMARY                 = UINavigationController(rootViewController:summary)
        
        SUMMARY.tabBarItem          = UITabBarItem(title:"Summary", image:nil, tag:2)
        
        
        
        let TABS                    = TabBarController()
        
        TABS.setViewControllers([CATEGORIES,SUMMARY], animated:true)
        
        TABS.selectedViewController = CATEGORIES
        
        
        WINDOW.rootViewController   = TABS
        
        WINDOW.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    
    

    
}


extension AppDelegate
{
    static var rootViewController : UIViewController {
        return UIApplication.sharedApplication().keyWindow!.rootViewController!
    }

}




// HELP/CATEGORIES+ITEMS+SUMMARY SCREEN, ONCE, STORE IN DEFAULTS/UIALERTCONTROLLER.ALERT
// TAB ICONS
// NAVIGATOR TITLE
// CHANGE TAB NAME 'ITEMS' TO 'GROCERIES'

// ITEMS/ADD NOTE BASED ON UILongPressGestureRecognizer on cell
// SETTINGS PAGE?
// SETTINGS/ADD COLOR THEMES? APPLE,RAINBOW,GRAPE,STRAWBERRY,PLAIN
// SETTINGS/THEMES/SATURATION?
// SETTINGS/FONT TYPE,SIZE,BOLD/PLAIN
// SAVE SUMMARY?








