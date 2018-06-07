//
//  AppDelegate.swift
//  TPFinal-iOS
//
//  Created by Steven F. on 07/06/2018.
//  Copyright © 2018 Steven F. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Custom Links
    static let APP_STORE_URL = ""
    static let APP_DEVELOPER_URL = "https://www.stevenfrancony.fr/"
    
    // Style on Navbars
    var navigationBar = UINavigationBar.appearance()
    var tabBar = UITabBar.appearance()
    var searchBar = UIBarButtonItem.appearance()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Change bar style propertys for all controllers
        navigationBar.tintColor = UIColor().colorFromHexa(rgbValue: UIColor.applicationColor.whiteColor.rawValue)
        navigationBar.barTintColor = UIColor().colorFromHexa(rgbValue: UIColor.applicationColor.primaryColor.rawValue)
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        // Change status bar text color
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Change tab bar color for all controllers
        tabBar.tintColor = UIColor().colorFromHexa(rgbValue: UIColor.applicationColor.whiteColor.rawValue)
        tabBar.barTintColor = UIColor().colorFromHexa(rgbValue: UIColor.applicationColor.primaryColor.rawValue)
        
        // Change SearchBar button color
        searchBar.tintColor = UIColor().colorFromHexa(rgbValue: UIColor.applicationColor.whiteColor.rawValue)
                
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

