//
//  AppDelegate.swift
//  MBS
//
//  Created by Rustan Corpuz on 6/24/15.
//  Copyright (c) 2015 RightClick. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4
import ParseUI
import Onboard


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let userHasOnboardedKey = "user_has_onboarded"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        User.registerSubclass()
        Advertisement.registerSubclass()
   
        // Initialize Parse.
        Parse.setApplicationId("G4BT3C86cGOYTHui6hoYNgr3n1ULiXIKz3vyoNiG",
            clientKey: "wqJw5KkRsmez6BlzrltwRbkxY3SSENqYOZm0BnMJ")
        
        //Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        if let barFont = UIFont(name: "Avenir-Heavy", size: 17.0) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName:barFont, NSForegroundColorAttributeName:UIColor.whiteColor()]
        }
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor.facebookBlue()
        UINavigationBar.appearance().translucent = false
        
        var userHasOnboardedAlready = NSUserDefaults.standardUserDefaults().boolForKey(userHasOnboardedKey);
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
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    
    
}

