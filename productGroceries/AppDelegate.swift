//
//  AppDelegate.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/4/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import UIKit
import CoreData

// TODO: ADD ANIMATED TRANSITIONS BETWEEN TAB SWITCHING
// TODO: ADD SEARCH ON CATEGORIES AND SUMMARY PAGES

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private static var __tabBarController:UITabBarController?
    private static var __navigatorForCategories:UINavigationController?
    private static var __navigatorForSettings:UINavigationController?
    private static var __instance:AppDelegate?
    
    class var instance:AppDelegate {
        return __instance!
    }
    
    class var tabBarController:UITabBarController {
        return __tabBarController!
    }
    
    class var navigatorForCategories:UINavigationController {
        return __navigatorForCategories!
    }
    
    class var navigatorForSettings:UINavigationController {
        return __navigatorForSettings!
    }
    
    class var rootViewController:UIViewController {
        return __tabBarController!
    }
    
    lazy var preferences            : Preferences               = {
        let result = Preferences()
        return result
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        
        AppDelegate.__instance      = self
        
        Audio.initialize()
        
//        Store.Manager.itemRemoveAll()
//        Store.Manager.createCategories()
//        Store.Manager.clearHelpFlags()
//        Store.Manager.reset()
//        NSUserDefaults.clear()
        Store.Manager.resetIfRequired()
        
        // a window displays views and distributes events
        window                      = UIWindow()
        
        let WINDOW                  = window!
        
        WINDOW.screen               = UIScreen.main
        WINDOW.bounds               = WINDOW.screen.bounds
        WINDOW.windowLevel          = UIWindowLevelNormal
        
        
        
        let categories              = ControllerOfCategories()
        
        let CATEGORIES              = UINavigationController(rootViewController:categories)
        
        AppDelegate.__navigatorForCategories     = CATEGORIES
        
        CATEGORIES.tabBarItem       = UITabBarItem(title:"Items", image:UIImage(named:"image-icon-tabbaritem-categories-default"), tag:1)
        
        CATEGORIES.setNavigationBarHidden(false, animated:true)
        
        
        
        let summary                 = ControllerOfSummary()
        summary.title               = "Summary"

        let SUMMARY                 = UINavigationController(rootViewController:summary)
        
        SUMMARY.tabBarItem          = UITabBarItem(title:"Summary", image:UIImage(named:"image-icon-tabbaritem-summary-default"), tag:2)

        
        
        let settings                = ControllerOfSettings()
        settings.title              = "Settings"
        
        let SETTINGS                = UINavigationController(rootViewController:settings)
        
        SETTINGS.tabBarItem         = UITabBarItem(title:"Settings", image:UIImage(named:"image-icon-tabbaritem-settings-default"), tag:3)
        
        AppDelegate.__navigatorForSettings     = SETTINGS
        
        
        let TABS                    = UITabBarController()
        
        TABS.setViewControllers([CATEGORIES,SUMMARY,SETTINGS], animated:true)
        
        TABS.selectedViewController = CATEGORIES
        
        AppDelegate.__tabBarController = TABS
        
        
        WINDOW.rootViewController   = TABS
        
        WINDOW.makeKeyAndVisible()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        preferences.synchronize()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        preferences.synchronize()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        preferences.synchronize()
        AppDelegate.saveContext()
    }
    
    // MARK: - Core Data stack
    
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        return AppDelegate.persistentContainer.persistentStoreCoordinator
    }()

    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "productGroceries")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = AppDelegate.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Older Stuff
    
    static var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.tinygamefactory.productWikieHere" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    static var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "productGroceries", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    static var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = AppDelegate.persistentStoreCoordinator
        return managedObjectContext
    }()

}
