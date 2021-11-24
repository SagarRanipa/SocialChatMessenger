//
//  AppDelegate.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-08-17.
//

import UIKit
import Firebase
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var firstRun: Bool?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        

        Messaging.messaging().delegate = self
        requestPushNotificationPermission()
        
       // print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        application.registerForRemoteNotifications()
        
        firstRunCheck()
        LocationManager.shared.startUpdating()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //MARK: - Remote Notifications
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notification ", error.localizedDescription)
    }
    
    private func requestPushNotificationPermission() {
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, _) in
            
        }
    }
    
    private func updateUserPushId(newPushId: String) {
        if var user = User.currentUser {
            user.pushID = newPushId
            saveUserLocally(user)
            FirebaseUserListener.shared.updateUserInFirestore(user)
        }
    }
    
    //MARK: - FirstRun
    
    private func firstRunCheck() {
        
        firstRun = userDefaults.bool(forKey: kFIRSTRUN)
        if !firstRun! {
            
            let status = Status.allCases.map{ $0.rawValue }
            
            userDefaults.set(status, forKey: kSTATUS)
            userDefaults.set(true, forKey: kFIRSTRUN)
            
            userDefaults.synchronize()
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        updateUserPushId(newPushId: fcmToken)
    }
}

