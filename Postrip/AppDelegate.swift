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
import ParseFacebookUtilsV4
import ParseTwitterUtils

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
        PFAnalytics.trackAppOpenedWithLaunchOptions(inBackground: launchOptions, block: nil)
        PFFacebookUtils.initializeFacebook()

        // Twitter configuration
        PFTwitterUtils.initialize(withConsumerKey: "RSUs2WNRFRyDeXamh0leU5aYW", consumerSecret: "375wRNaYJ6H1MFwHOX3Nbz4YGHV8hwdx3LYNi95z0jQgWLKmDT")
        
        //call login function
        login()
        
        // color of window
        window?.backgroundColor = .black
        
        // push notification enablement
        application.applicationIconBadgeNumber = 0  // clear badge when application is launched
        
        if #available(iOS 10.0, *) {
            if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
                    window?.rootViewController?.present(ViewController(), animated: true, completion: nil)
                    notificationReceived(notification: notification as [String : AnyObject])
                } else {
                    DispatchQueue.main.async {
                        let center = UNUserNotificationCenter.current()
                        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
                        center.requestAuthorization(options: options, completionHandler: { authorized, error in
                            if authorized {
                                application.registerForRemoteNotifications()
                            }
                        })
                    }
                }
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("APNs registration failed: \(error)")
    }
    

    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        
        print("Push notification received: \(data)")
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
        application.applicationIconBadgeNumber = 0; // Clear badge when app is or resumed
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        // FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let sourceApplication : String? = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: sourceApplication, annotation: nil)
    }
    
    
    func notificationReceived(notification: [String:AnyObject]) {
        let viewController = window?.rootViewController
        let view = viewController as? postVC
        view?.addNotification(title: getAlert(notification: notification ).0, body: getAlert(notification: notification ).1)
        
    }
    
    private func getAlert(notification: [String:AnyObject]) -> (String, String) {
        let aps = notification["aps"] as? [String:AnyObject]
        let alert = aps?["alert"] as? [String:AnyObject]
        let title = alert?["title"] as? String
        let body = alert?["body"] as? String
        return (title ?? "-", body ?? "-")
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

