//
//  AppDelegate.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/4/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import UIKit
import CoreData
import ASToolkit

// TODO: ADD ANIMATED TRANSITIONS BETWEEN TAB SWITCHING
// TODO: ADD SEARCH/FILTER ON CATEGORIES AND SUMMARY PAGES

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    class var instance                      : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    class var tabBarController              : UITabBarController {
        return UIApplication.rootViewController as! UITabBarController
    }
    
    class var navigatorForCategories        : UINavigationController {
        return tabBarController.customizableViewControllers![0] as! UINavigationController
    }
    
    class var navigatorForSummary           : UINavigationController {
        return tabBarController.customizableViewControllers![1] as! UINavigationController
    }
    
    class var navigatorForSettings          : UINavigationController {
        return tabBarController.customizableViewControllers![2] as! UINavigationController
    }
    
    class var rootViewController            : UIViewController {
        return UIApplication.rootViewController
    }
    
    lazy var preferences                    : Preferences = {
        let result = Preferences()
        result.reset() // TODO: REMOVE, THIS IS FOR DEBUGGING PURPOSES ONLY
        result.themeLoadCurrent()
        return result
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        
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
        
        
        
        
        

        
        if false {
            let picker = GenericControllerOfPickerOfColor()
            picker.rowHeight = 80
            let colors:[[UIColor]] = [
                [.red,.orange,.yellow],
                [.blue,.green,.aqua],
                [.white],
                [.red,.orange,.yellow],
                [.blue,.green,.aqua],
                [.white,.lightGray,.gray,.darkGray,.black],
                [.red,.orange,.yellow],
                [.blue,.green,.aqua],
                [.white,.lightGray,.gray,.darkGray,.black],
                [.red,.orange,.yellow],
                [.blue,.green,.aqua],
                [.white,.lightGray,.gray,.darkGray,.black],
                [.red,.orange,.yellow],
                [.blue,.green,.aqua],
                [.white,.lightGray,.gray,.darkGray,.black],
                [.red,.orange,.yellow],
                [.blue,.green,.aqua],
                [.white,.lightGray,.gray,.darkGray,.black],
                [.red,.orange,.yellow],
                [.blue,.green,.aqua],
                [.gray],
            ]
            picker.flavor = .matrixOfSolidCircles(selected: .white, colors: colors, diameter: 60, space: 16)
            WINDOW.rootViewController = picker
            WINDOW.makeKeyAndVisible()
        }
        else if false {
            
            let picker = PickerOfColorWithSliders.create(withComponents: [
                .colorDisplay           (height:64,kind:.dot),
//                .sliderRed              (height:16),
//                .sliderGreen            (height:16),
//                .sliderBlue             (height:16),
                .sliderAlpha            (height:32),
                .sliderHue              (height:16),
                .sliderSaturation       (height:16),
                .sliderBrightness       (height:16),
//                .sliderCyan             (height:32),
//                .sliderMagenta          (height:32),
//                .sliderYellow           (height:32),
//                .sliderKey              (height:32),
                .storageDots            (radius:16, columns:6, rows:3, colors:[.white,.gray,.black,.orange,.red,.blue,.green,.yellow])
                ])
            let vc = UIViewController()
            picker.frame = UIScreen.main.bounds
            vc.view = picker
            picker.backgroundColor = UIColor(white:0.95)
            picker.handler = { color in
                print("new color\(color)")
            }
            picker.set(color:UIColor(rgb:[0.64,0.13,0.78]), animated:true)
            WINDOW.rootViewController = vc
            WINDOW.makeKeyAndVisible()
        }
        else {
            WINDOW.rootViewController   = buildRootViewController()
            WINDOW.makeKeyAndVisible()
            preferences.synchronize()
        }
        
        
        
        
        
        
        
        return true
    }

    func buildRootViewController() -> UIViewController {
    
        let categories              = ControllerOfCategories()
        let summary                 = ControllerOfSummary()
        let settings                = ControllerOfSettings()
        
        
        categories.title            = "Aisles"
        summary.title               = "Summary"
        settings.title              = "Settings"
        
        
        
        let CATEGORIES              = UINavigationController(rootViewController:categories)
        let SUMMARY                 = UINavigationController(rootViewController:summary)
        let SETTINGS                = UINavigationController(rootViewController:settings)
        
        
        CATEGORIES.setNavigationBarHidden(false, animated:true)

        CATEGORIES.tabBarItem       = UITabBarItem(title:categories.title,  image:nil, tag:1)
        SUMMARY.tabBarItem          = UITabBarItem(title:summary.title,     image:nil, tag:2)
        SETTINGS.tabBarItem         = UITabBarItem(title:settings.title,    image:nil, tag:3)

        
        let TABS                    = UITabBarController()
        
        TABS.setViewControllers([CATEGORIES,SUMMARY,SETTINGS], animated:true)
        
        TABS.selectedViewController = CATEGORIES

        return TABS
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
