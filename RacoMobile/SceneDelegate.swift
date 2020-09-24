//
//  SceneDelegate.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 06/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SWRevealViewController
import Alamofire_SwiftyJSON
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    var url: String?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let loginVC = storyboard.instantiateViewController (withIdentifier: "logInVC") as! LogInViewController
        let initVC = storyboard.instantiateViewController (withIdentifier: "revealVC") as! SWRevealViewController
        
        window = UIWindow(windowScene: windowScene)
		
        if (userToken.isValid) {
            let reqParameters: Parameters = ["format": "json"]
            let reqHeaders: HTTPHeaders = ["Authorization": ("Bearer " + userToken.accessToken)]
            Alamofire.request("https://api.fib.upc.edu/v2/jo/", method: .get, parameters: reqParameters, encoding: URLEncoding.default, headers: reqHeaders).responseSwiftyJSON { (response) in
                if let value = response.result.value {
                    user.setNom(nom: value["nom"].stringValue)
                    user.setCognoms(cognoms: value["cognoms"].stringValue)
                    user.setEmail(email: value["email"].stringValue)
                    user.setUsername(username: value["username"].stringValue)
                }
            }
            
            if (userToken.isValid) {
                let pushManager = PushNotificationManager(userID: user.getUsername())
                pushManager.registerForPushNotifications()
            }
            
            window?.rootViewController = initVC
        } else {
            window?.rootViewController = loginVC
        }
        
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
		var firstTime: Bool = true
		
		startRequest.returnsObjectsAsFaults = false
		do {
			let result = try context.fetch(startRequest)
			for data in result as! [NSManagedObject] {
				firstTime = data.value(forKey: "firstTime") as! Bool
			}
			
			if (!firstTime && TokenResponse.isExpired()) {
				TokenResponse.refreshOAuthToken(withCompletionHandler: {})
			}
			
			if (firstTime == true) {
				newStartSetting.setValue(false, forKey: "firstTime")
				appDelegate.saveContext()
			}
			
		} catch {
			
			print("Core Data Failed")
		}
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        // (UIApplication.shared.delegate as! AppDelegate).scheduleBackgroundAvisosFetch()
        // (UIApplication.shared.delegate as! AppDelegate).scheduleOAuthRenew()
        
    }    
    
}

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
