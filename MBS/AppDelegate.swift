//
//  AppDelegate.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/24/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4
import Onboard


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let userHasOnboardedKey = "user_has_onboarded"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        //        self.window!.backgroundColor = UIColor.whiteColor()
        
        // Initialize Parse.
        Parse.setApplicationId("G4BT3C86cGOYTHui6hoYNgr3n1ULiXIKz3vyoNiG",
            clientKey: "wqJw5KkRsmez6BlzrltwRbkxY3SSENqYOZm0BnMJ")
        
        //Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        //UIApplication.sharedApplication().statusBarHidden = true
        
        //        UILabel.appearance().substituteFontName = "Avenir"
        //        UILabel.appearance().substituteFontNameBold = "Avenir-Black"
        
        if let barFont = UIFont(name: "Avenir-Book", size: 17.0) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName:barFont]
        }
        
        
        UINavigationBar.appearance().tintColor = UIColor.lightGrayColor()
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        
        
        
        var userHasOnboardedAlready = NSUserDefaults.standardUserDefaults().boolForKey(userHasOnboardedKey);
        
        //                PFUser.logOut()
        
        if userHasOnboardedAlready {
            self.setupNormalRootVC(false);
        }
        else {
            self.window?.rootViewController = self.generateOnboardingViewController()
        }
        
        
        self.window!.makeKeyAndVisible()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func generateOnboardingViewController() -> OnboardingViewController {
        let firstPage: OnboardingContentViewController = OnboardingContentViewController(title: "Lorem ipsum dolor sit amet", body: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eius aliquid dolor, dolorum voluptates aspernatur magni fugiat placeat enim. ", image: nil, buttonText: "Enable Location Services") {
            println("Do something here...");
        }
        
        
        let secondPage: OnboardingContentViewController = OnboardingContentViewController(title: "Lorem ipsum dolor sit amet", body: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eius aliquid dolor, dolorum voluptates aspernatur magni fugiat placeat enim. ", image: UIImage(named:
            "red"), buttonText: "Connect With Facebook") {
                println("Do something else here...");
        }
        
        
        let thirdPage: OnboardingContentViewController = OnboardingContentViewController(title: "Lorem ipsum dolor sit amet", body: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eius aliquid dolor, dolorum voluptates aspernatur magni fugiat placeat enim. ", image: UIImage(named:
            "yellow"), buttonText: "Let's Get Started") {
                self.handleOnboardingCompletion()
        }
        
        let onboardingVC: OnboardingViewController = OnboardingViewController(backgroundImage: UIImage(named: "street"), contents: [firstPage, secondPage, thirdPage])
        
        onboardingVC.titleFontSize = 28;
        onboardingVC.bodyFontSize = 18;
        onboardingVC.topPadding = 0;
        //        onboardingVC.underIconPadding = 10;
        //        onboardingVC.underTitlePadding = 250;
        //        onboardingVC.bottomPadding = 20;
        
        
        
        return onboardingVC
    }
    
    
    func handleOnboardingCompletion() {
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: userHasOnboardedKey)
        setupNormalRootVC(true)
    }
    
    func setupNormalRootVC(animated : Bool) {
        
        if PFUser.currentUser() == nil {
            if animated {
                UIView.transitionWithView(self.window!, duration: 0.5, options:.TransitionCrossDissolve, animations: {
                    () -> Void in
                    self.window!.rootViewController = LoginConfigViewController()
                    }, completion:nil)
            }
                
            else {
                self.window?.rootViewController = LoginConfigViewController()
            }
        }
        
        
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
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
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

