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

var USMNTgoalkeepers: [Player] = []
var USMNTdefenders: [Player] = []
var USMNTmidfielders: [Player] = []
var USMNTforwards: [Player] = []

var U23goalkeepers: [Player] = []
var U23defenders: [Player] = []
var U23midfielders: [Player] = []
var U23forwards: [Player] = []

var U20goalkeepers: [Player] = []
var U20defenders: [Player] = []
var U20midfielders: [Player] = []
var U20forwards: [Player] = []

var U17goalkeepers: [Player] = []
var U17defenders: [Player] = []
var U17midfielders: [Player] = []
var U17forwards: [Player] = []

var blockedUIDs: [String] = []

let gcmMessageIDKey = "gcm.message_id"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
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
        
        DispatchQueue.global().async {
            
            scrapeUSMNTRosterFromWikipedia()
            scrapeU23RosterFromWikipedia()
            scrapeU20RosterFromWikipedia()
            scrapeU17RosterFromWikipedia()
            loadBlockedUsers()
            
        }
        
        // ask user for permission to send remote notifications
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
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

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }

}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print full message.
        print(userInfo)

        completionHandler()
    }
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      
        print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict:[String: String] = ["token": String(describing: fcmToken)]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
    }
    
}

