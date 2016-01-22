//
//  AppDelegate.swift
//
//
//  Created by Quinton Wall on 12/21/15.
//  Copyright © 2015 Quinton Wall. All rights reserved.
//

import UIKit
import CoreData
import WatchKit


//import OAuthSwift

let RemoteAccessConsumerKey = "3MVG9fMtCkV6eLhdjZ8TO0bd8hGzu5J5yQgUxxSuCecbgoXyi.K29XllYaR_X0S5uGpH_kLhPbR2bMOys1U2D";
let OAuthRedirectURI        = "mobilesdk://success";
let scopes = ["api"];
let approvalsHelper: ApprovalsHandler = ApprovalsHandler()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
   
    
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
    }
    
    
    
    // MARK: - Salesforce Auth Stuff
    
    override
    init()
    {
        super.init()
        
        
        //let appGroupID = "group.com.gyspycode.SFTasks"
        //let defaults = NSUserDefaults(suiteName: appGroupID)
        
        
        SFLogger.setLogLevel(SFLogLevel.Debug)
        
        
        SalesforceSDKManager.sharedManager().connectedAppId = RemoteAccessConsumerKey
        SalesforceSDKManager.sharedManager().connectedAppCallbackUri = OAuthRedirectURI
        SalesforceSDKManager.sharedManager().authScopes = scopes
        SalesforceSDKManager.sharedManager().postLaunchAction = {
            [unowned self] (launchActionList: SFSDKLaunchAction) in
            let launchActionString = SalesforceSDKManager.launchActionsStringRepresentation(launchActionList)
            self.log(SFLogLevel.Info, msg:"Post-launch: launch actions taken: \(launchActionString)");
            //self.setupRootViewController();
        }
        SalesforceSDKManager.sharedManager().launchErrorAction = {
            [unowned self] (error: NSError?, launchActionList: SFSDKLaunchAction) in
            if let actualError = error {
                self.log(SFLogLevel.Error, msg:"Error during SDK launch: \(actualError.localizedDescription)")
            } else {
                self.log(SFLogLevel.Error, msg:"Unknown error during SDK launch.")
            }
  
        }
        SalesforceSDKManager.sharedManager().postLogoutAction = {
            [unowned self] in
            self.handleSdkManagerLogout()
        }
        SalesforceSDKManager.sharedManager().switchUserAction = {
            [unowned self] (fromUser: SFUserAccount?, toUser: SFUserAccount?) -> () in
            self.handleUserSwitch(fromUser, toUser: toUser)
        }
        
        
        approvalsHelper.register()
    }
    
    
    func handleSdkManagerLogout()
    {
        //todo
    }
    
    func handleUserSwitch(fromUser: SFUserAccount?, toUser: SFUserAccount?)
    {
        //todo
    }
    
    
}

