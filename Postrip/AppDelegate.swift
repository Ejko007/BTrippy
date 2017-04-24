//
//  AppDelegate.swift
//  Postrip
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse
import UserNotifications
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // light status bar
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        // Parse configuration
        let parseConfig = ParseClientConfiguration { (ParseMutableClientConfiguration) in            
            ParseMutableClientConfiguration.applicationId = "giMy5zrPdxGS6K7n63F8zbZKc7dAPc8bCmOG4G94"
            ParseMutableClientConfiguration.clientKey = "Xm3Cw5nCLP2SUd59TSXgs3hbG9GcbiH8RfCP4dA7"
            ParseMutableClientConfiguration.server = "https://pg-app-ff0ppowy4lzielkcxeri34vrpddf9v.scalabl.cloud/1/"
        }
        Parse.enableLocalDatastore()
        Parse.initialize(with: parseConfig)
        
        // Facebook configuration
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        //call login function
        login()
        
        // color of window
        window?.backgroundColor = .white
        
        // push notification enablement
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            center.requestAuthorization(options: options, completionHandler: { authorized, error in
                if authorized {
                    application.registerForRemoteNotifications()
                }
            })
        }
    
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let sourceApplication : String? = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: sourceApplication, annotation: nil)
    }

    func login() {
        
        // remeber user's login
        
        let username : String? = UserDefaults.standard.string(forKey: "username")
        
        if username != nil {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myTabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
            window?.rootViewController = myTabBar
        }
    }
}

