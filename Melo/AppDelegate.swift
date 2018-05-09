//
//  AppDelegate.swift
//  Melo
//
//  Created by Dipali Bajaj on 4/16/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import AVFoundation

//Setting up colors for Melo gradient.
let primaryColor = UIColor(red: 116/255, green: 139/255, blue: 246/255, alpha: 1)
let secondaryColor = UIColor(red: 74/255, green: 95/255, blue: 239/255, alpha: 1)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        let authListener = Auth.auth().addStateDidChangeListener { auth, user in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if user != nil {
                UserService.observeUserProfile(user!.uid) {userProfile in
                    UserService.currentUserProfile = userProfile
                    }
                //Go to tab bar.
                let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                self.window?.rootViewController = controller
                //Shows the screen.
                self.window?.makeKeyAndVisible()
            }
            else {
                
                UserService.currentUserProfile = nil
                
                //Go to initial menu screen.
                let controller = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
                self.window?.rootViewController = controller
                //Shows the screen.
                self.window?.makeKeyAndVisible()
            }
        }
        
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Melo")
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

