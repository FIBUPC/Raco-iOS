//
//  AppDelegate.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 06/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import Alamofire
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		// Firebase
		FirebaseApp.configure()
		
		if (userToken.isValid) {
			let pushManager = PushNotificationManager(userID: user.getUsername())
			pushManager.registerForPushNotifications()
		}
		
		// Background tasks
		/*BGTaskScheduler.shared.register(
			forTaskWithIdentifier: "com.alvaroarinocabau.RacoMobile.updateAvisos",
			using: nil) { (task) in
				self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
		}*/
		
		return true
	}
	
	private func application(_ application: UIApplication, didReceive notification: UNNotificationRequest) {
		UIApplication.shared.applicationIconBadgeNumber = 0
	}
	
	func handleAppRefreshTask(task: BGAppRefreshTask) {
		task.expirationHandler = {
			task.setTaskCompleted(success: false)
			AvisosTableViewController().request?.cancel()
		}
		
		AvisosTableViewController().obtenirAvisosHandler() { (avis, oldCount) in
			if AvisosTableViewController().avisos.count > oldCount {
				AvisosTableViewController().sendNotification()
			}
			
			task.setTaskCompleted(success: true)
		}
		
		scheduleBackgroundAvisosFetch()
	}
	
	func scheduleImagefetcher() {
		let request = BGProcessingTaskRequest(identifier: "com.SO.imagefetcher")
		request.requiresNetworkConnectivity = false // Need to true if your task need to network process. Defaults to false.
		request.requiresExternalPower = false
		//If we keep requiredExternalPower = true then it required device is connected to external power.
		
		request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60) // fetch Image Count after 1 minute.
		//Note :: EarliestBeginDate should not be set to too far into the future.
		do {
			try BGTaskScheduler.shared.submit(request)
		} catch {
			print("Could not schedule image fetch: (error)")
		}
	}
	
	func scheduleBackgroundAvisosFetch() {
		let avisosFetchTask = BGAppRefreshTaskRequest(identifier: "com.alvaroarinocabau.RacoMobile.updateAvisos")
		avisosFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 10)
		do {
			try BGTaskScheduler.shared.submit(avisosFetchTask)
		} catch {
			print("Unable to submit task: \(error.localizedDescription)")
		}
	}
	
	func handleOAuthRenew(task: BGAppRefreshTask) {
		task.expirationHandler = {
			task.setTaskCompleted(success: false)
			TokenResponse.request?.cancel()
		}
		
		TokenResponse.refreshOAuthToken {
			task.setTaskCompleted(success: true)
		}
		
		scheduleOAuthRenew()
	}
	
	func scheduleOAuthRenew() {
		let ouathRenewTask = BGAppRefreshTaskRequest(identifier: "com.alvaroarinocabau.RacoMobile.oAuthRenew")
		ouathRenewTask.earliestBeginDate = Date(timeIntervalSinceNow: 21600)
		do {
			try BGTaskScheduler.shared.submit(ouathRenewTask)
		} catch {
			print("Unable to submit task: \(error.localizedDescription)")
		}
	}
	
	
	// MARK: - UISceneSession Lifecycle
	
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
	
	// MARK: - Core Data stack
	
	lazy var persistentContainer: NSPersistentContainer = {
		/*
		The persistent container for the application. This implementation
		creates and returns a container, having loaded the store for the
		application to it. This property is optional since there are legitimate
		error conditions that could cause the creation of the store to fail.
		*/
		let container = NSPersistentContainer(name: "RacoMobile")
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
	
	func saveContext () {
		let context = persistentContainer.viewContext
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
}

