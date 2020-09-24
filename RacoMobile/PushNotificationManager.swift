//
//  PushNotificationManager.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 02/03/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import Firebase
import FirebaseMessaging
import UIKit
import UserNotifications

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    let userID: String
    init(userID: String) {
        self.userID = userID
        super.init()
    }

    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }

        UIApplication.shared.registerForRemoteNotifications()
        //updateFirestorePushTokenIfNeeded()
    }

    /*func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            // Add a new document in collection "cities"
            Firestore.firestore().collection("users").document(userID).setData([
                "username": userID,
                "notificationsToken": token
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }*/

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        UIApplication.shared.applicationIconBadgeNumber += 1
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        //updateFirestorePushTokenIfNeeded()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
    }
}
