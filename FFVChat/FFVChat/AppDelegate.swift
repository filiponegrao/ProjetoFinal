//
//  AppDelegate.swift
//  ProjetoFinal
//
//  Created by Filipo Negrao on 09/09/15.
//  Copyright (c) 2015 FFV. All rights reserved.
//

import UIKit
import CoreData
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        Parse.setApplicationId("nxY5lzIPinULd8EmSTxb09vxmVx08tyC1Y2Rt2HK",
            clientKey: "ULiq579xkqwfJF3OKjMJeSLYX42UQ54jvEydaB8s")
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        BlackList.initBlackList()
        TheJudger.Singleton.inicializandoJudger()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let usercondition = DAOUser.sharedInstance.isLoged()
        
        if(usercondition == UserCondition.userLogged)
        {
            if(PFUser.currentUser() != nil)
            {
                let contacts = AppNavigationController()
                self.window?.rootViewController = contacts
            }
            else
            {
                let contacts = LoadingInfo_ViewController(nibName: "LoadingInfo_ViewController", bundle: nil)
                self.window?.rootViewController = contacts

            }
        }
        else if(usercondition == UserCondition.userLoggedOut)
        {
            let login = Login_ViewController(nibName: "Login_ViewController", bundle: nil)
            self.window?.rootViewController = login
        }
        else if(usercondition == UserCondition.incompleteRegister)
        {
            let validate = FacebookRegister_ViewController(nibName: "FacebookRegister_ViewController", bundle: nil)
            self.window?.rootViewController = validate
        }
        else if(usercondition == UserCondition.termsUnaccepted)
        {
            let terms = Privacy_ViewController(nibName: "Privacy_ViewController", bundle: nil)
            self.window?.rootViewController = terms
        }
        else if(usercondition == UserCondition.contactsNotImported)
        {
            let contacts = Import_ViewController(nibName: "Import_ViewController", bundle: nil)
            self.window?.rootViewController = contacts
        }
        else if(usercondition == UserCondition.notLinkedFacebook)
        {
            let contacts = AppLoginImport_ViewController()
            self.window?.rootViewController = contacts
        }
        
        self.window?.makeKeyAndVisible()
        
        //Status bar color
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        
        // Register for Push Notitications *******************************
        
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:®didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
    
        
        if application.respondsToSelector("registerUserNotificationSettings:")
        {
            let userNotificationTypes = (UIUserNotificationType.Alert.rawValue | UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Sound.rawValue)
            
            let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.init(rawValue: userNotificationTypes), categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        else
        {
            let type = UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue | UIUserNotificationType.Sound.rawValue
            
            application.registerUserNotificationSettings(UIUserNotificationSettings.init(forTypes: UIUserNotificationType.init(rawValue: type), categories: nil))
        }
        // Fim das configuracoes de notificacao ********************************
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)        
    }
    
    //Facebook
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
            return FBSDKApplicationDelegate.sharedInstance().application( application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        DAOPostgres.sharedInstance.stopObserve()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0

    }
    
    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        
    }
    
    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        if(DAOUser.sharedInstance.isLoged() == UserCondition.userLogged)
        {
            DAOPostgres.sharedInstance.startObserve()
            DAOFriendRequests.sharedInstance.friendsAccepted()
            DAOFriendRequests.sharedInstance.loadRequests()
            DAOContacts.sharedInstance.refreshContacts()
            
            //De teste, ou seja tirar depois de arrumar direitinho:
            DAOPrints.sharedInstance.getPrintscreenNotificationsFromParse()
        }
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0

    }
    
    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    
    //PARSE NOTIFICATION ***********
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        print("didReceiveRemoteNotification \(userInfo)")
        let notification = userInfo as NSDictionary
        //Isso causava o alerta no meio da porra da aplicação
//        PFPush.handlePush(userInfo)
        
        if (application.applicationState == UIApplicationState.Background || application.applicationState == UIApplicationState.Inactive)
        {
            UIApplication.sharedApplication().applicationIconBadgeNumber += 1
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
            
//            self.window?.rootViewController
        }
        
        if(PFUser.currentUser() != nil)
        {
            if(notification.valueForKey("do") as! String == appNotification.friendRequest.rawValue)
            {
                print("carregando friend requests ordenado por notifiacao")
                DAOFriendRequests.sharedInstance.loadRequests()
            }
            else if(notification.valueForKey("do") as! String == appNotification.requestAccepted.rawValue)
            {
                print("Adicionando amigo ordenado por notifiacao")
                DAOFriendRequests.sharedInstance.friendsAccepted()
            }
            else if(notification.valueForKey("do") as! String == appNotification.messageReceived.rawValue)
            {
                DAOPostgres.sharedInstance.getUnreadMessages()
            }
            else if(notification.valueForKey("do") as! String == appNotification.printscreen.rawValue)
            {
//                NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.printScreenReceived)
                DAOPrints.sharedInstance.getPrintscreenNotificationsFromParse()
            }
        }
    }
    
    
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "FilipoNegrao.TesteBD" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
}

