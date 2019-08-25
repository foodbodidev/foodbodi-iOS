//
//  AppDelegate.swift
//  FoodBody
//
//  Created by Toan Tran on 6/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn;
import GoogleMaps
import Firebase
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        IQKeyboardManager.shared.enable = true // use to manage keyboard
        GIDSignIn.sharedInstance().clientID = FbConstants.REVERSED_CLIENT_ID;
        GMSServices.provideAPIKey(FbConstants.MAP_API_KEY)
        GMSPlacesClient.provideAPIKey(FbConstants.MAP_API_KEY)
        GIDSignIn.sharedInstance().signOut()
        let db = Firestore.firestore()
        db.collection("restaurants")
            .addSnapshotListener { querySnapshot, error in

                if  querySnapshot?.documents.count ?? 0 <= 0 {
                    print("Error fetching documents: \(error!)")
                    return
                }else{
                    let dict:Dictionary = ["KquerySnapshot":querySnapshot]
                    NotificationCenter.default.post(name:.kFb_update_restaurant, object: nil, userInfo: dict as [AnyHashable : Any]);
                }
        }
        db.collection("notifications").whereField("receiver", isEqualTo: AppManager.user?.email ?? "").whereField("read", isEqualTo: false).addSnapshotListener { (querySnapshot, error) in
            let alert = UIAlertController(title:nil, message: "Add reservation success", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default) {
                UIAlertAction in
                //go to company information.
            }
            alert.addAction(action)
            self.window?.rootViewController?.navigationController?.present(alert, animated: true, completion: nil)
        }
        
        if AppManager.user?.token == nil{
            self.gotoWelcome()
        }else{
            
            self.gotoMainTab()
        }
		
		getCategory()
        return true
    }
	
	private func getCategory() {
		RequestManager.getCategoty { (data, error) in
			
			if let data  = data {
				AppManager.categoryList = data
			}
		}
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
    //MARK: handle follow.
    func gotoMainTab() -> Void {
        let mainTabbar:MainTabBarVC;
        mainTabbar = getViewController(className: MainTabBarVC.className, storyboard: FbConstants.mainSB) as! MainTabBarVC;
        let fodiMapVC = getViewController(className: FodiMapVC.className, storyboard: FbConstants.mainSB);
        let reservationVC = getViewController(className: ReservationVC.className, storyboard: FbConstants.mainSB);
        let profileVC = getViewController(className: ProfileVC.className, storyboard: FbConstants.mainSB);
        mainTabbar.viewControllers = [fodiMapVC, reservationVC, profileVC];
        let navMain = UINavigationController.init(rootViewController: mainTabbar);
        self.window?.rootViewController = navMain;
        UINavigationBar.appearance().barTintColor = UIColor.navColor()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    func gotoWelcome() -> Void {
        let welcomeVC = getViewController(className: WelComeVC.className, storyboard:FbConstants.AuthenticationSB);
        let navigation = UINavigationController.init(rootViewController: welcomeVC)
        navigation.navigationBar.shadowImage = UIImage.init()
        navigation.navigationBar.isTranslucent = false
        self.window?.rootViewController = navigation
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return .portrait
    }

}

