//
//  AppDelegate.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 1/10/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-2790005755690511~2126004075")
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        let homeVC = HomeVC()
        let calendarVC = CalendarVC()
        let forumHomeVC = ForumHomeVC()
        let rosterVC = RosterVC()
        let pollsVC = PollsVC()
        
        // rosterVC attributes
        rosterVC.tabBarItem.title = "Roster"
        rosterVC.navigationController?.navigationBar.isHidden = true
        rosterVC.tabBarItem.image = UIImage(named: "RosterIcon")
        
        // create polls navController
        let pollsNavController = UINavigationController(rootViewController: pollsVC)
        pollsNavController.navigationBar.isHidden = true
        pollsNavController.tabBarItem.title = "Polls"
        pollsNavController.tabBarItem.image = UIImage(named: "PollsIcon")
        
        // create home navController
        let homeNavController = UINavigationController(rootViewController: homeVC)
        homeNavController.navigationBar.isHidden = true
        homeNavController.tabBarItem.title = "Home"
        homeNavController.tabBarItem.image = UIImage(named: "HomeIcon")
        
        // create calendar navController
        let calendarNavController = UINavigationController(rootViewController: calendarVC)
        calendarNavController.navigationBar.isHidden = true
        calendarNavController.tabBarItem.title = "Calendar"
        calendarNavController.tabBarItem.image = UIImage(named: "CalendarIcon")
        
        // create forum navController
        let forumNavController = UINavigationController(rootViewController: forumHomeVC)
        forumNavController.navigationBar.isHidden = true
        forumNavController.tabBarItem.title = "Forum"
        forumNavController.tabBarItem.image = UIImage(named: "ForumIcon")
        
        // create tabBarController
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = #colorLiteral(red: 1, green: 0.6931049824, blue: 0.6924019456, alpha: 1)
        tabBarController.viewControllers = [homeNavController, calendarNavController, forumNavController, rosterVC, pollsNavController]
        
        // set tabController as root
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = tabBarController
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
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

