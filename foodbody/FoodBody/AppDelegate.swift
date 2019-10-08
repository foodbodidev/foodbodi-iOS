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
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
     //MARK: variable.
    var window: UIWindow?
    var locationManager:CLLocationManager? = nil;
    var currentLocation:CLLocationCoordinate2D = CLLocationCoordinate2D.init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //register firebase.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true // use to manage keyboard
        GIDSignIn.sharedInstance().clientID = FbConstants.REVERSED_CLIENT_ID;
        GMSServices.provideAPIKey(FbConstants.MAP_API_KEY)
        GMSPlacesClient.provideAPIKey(FbConstants.MAP_API_KEY)
        GIDSignIn.sharedInstance().signOut()
        //init location.
        self.initCurrentLocation();
        
        let db = Firestore.firestore()
        db.collection("restaurants")
            .addSnapshotListener { querySnapshot, error in

                if  querySnapshot?.documents.count ?? 0 <= 0 {
                    return
                }else{
                    let dict:Dictionary = ["KquerySnapshot":querySnapshot]
                    NotificationCenter.default.post(name:.kFb_update_restaurant, object: nil, userInfo: dict as [AnyHashable : Any]);
                }
        }
        
        if let user = AppManager.user {
            self.registerNotifycation(user: user);
        }else{
            NotificationCenter.default.addObserver(self, selector: #selector(onDidNotifiRegisterRestaurant(_:)), name: .kFB_notifi_registerRestaurant, object:nil)
        }
        getCategory()
        caculateRemainColor()
        if AppManager.user?.token == nil{
            self.gotoWelcome()
        }else{
            
            self.gotoMainTab()
        }
        return true
    }
    @objc func onDidNotifiRegisterRestaurant(_ notification: Notification)
    {
        if let user = AppManager.user
        {
            self.registerNotifycation(user: user);
        }
    }
    
    private func registerNotifycation(user:User){
        var email = "";
        email = user.email;
        print("preparing register notifications accept restaurant! \(email)")
        let db = Firestore.firestore()
        db.collection("notifications").whereField("receiver", isEqualTo: email).whereField("read", isEqualTo: false).addSnapshotListener { (documentSnapshot, error) in
            print("receive notifications accept restaurant!")
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            print("data \(document.metadata)")
            
            let alert = UIAlertController(title:nil, message: "Your restaurant is accepted by Fodimap!", preferredStyle: .alert)
            if (documentSnapshot?.documents.count)! > 0{
                let action = UIAlertAction(title: "Ok", style: .default) {
                    UIAlertAction in
                    if let id = AppManager.restaurant?.id{
                        RequestManager.notifySuccessRegisterRestaurant(text:id, completion: { (result, error) in
                            
                        })
                    }
                }
                alert.addAction(action)
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
	
	private func getCategory() {
		RequestManager.getCategoty { (data, error) in
			
			if let data  = data {
				AppManager.categoryList = data
			}
		}
	}
    
    
    private func caculateRemainColor() {
        AppManager.caculateCaloriesLeft()
    }
    private func initCurrentLocation(){
        self.locationManager = CLLocationManager();
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            if let localtionCheck = self.locationManager{
                localtionCheck.delegate = self;
                localtionCheck.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
                localtionCheck.startUpdatingLocation();
            }
        }else{
            let alert = UIAlertController(title:nil, message: "Location Service Disabled", preferredStyle: .alert)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil);
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationValue: CLLocationCoordinate2D = manager.location?.coordinate {
            self.currentLocation = locationValue;
            print(FbConstants.FoodbodiLog, (currentLocation))
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            let alert = UIAlertController(title:nil, message: "Your location not determined", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) {
                UIAlertAction in
            }
            alert.addAction(action)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil);
            break;
        case .denied:
            let alert = UIAlertController(title:nil, message: "Your location has been denied", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) {
                UIAlertAction in
            }
            alert.addAction(action)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil);
            break;
        case .authorizedAlways:
            self.locationManager?.startUpdatingLocation();
            break
        case .authorizedWhenInUse:
            self.locationManager?.startUpdatingLocation();
            let dict:NSDictionary = NSDictionary();
            NotificationCenter.default.post(name:.kFB_update_restaurant_when_enable_location, object: nil, userInfo: (dict as! [AnyHashable : Any]));
            break;
        default: break
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
        mainTabbar = getViewController(className: MainTabBarVC.className, storyboard: FbConstants.mainSB) as! MainTabBarVC
        //FodiMap.
        let fodiMapVC = getViewController(className: FodiMapVC.className, storyboard: FbConstants.mainSB)
        let navFodiMap = UINavigationController.init(rootViewController: fodiMapVC)
        //Reservation
        let reservationVC = getViewController(className: ReservationVC.className, storyboard: FbConstants.mainSB)
        let navReservation = UINavigationController.init(rootViewController: reservationVC)
        //Profile.
        let profileVC = getViewController(className: ProfileVC.className, storyboard: FbConstants.mainSB)
        let navProfile = UINavigationController.init(rootViewController: profileVC)
        
        mainTabbar.viewControllers = [navFodiMap, navReservation, navProfile];
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Style.Color.mainPurple]
        self.window?.rootViewController = mainTabbar;
    }
    func gotoWelcome() -> Void {
        let welcomeVC = getViewController(className: WelComeVC.className, storyboard:FbConstants.AuthenticationSB);
        let navigation = UINavigationController.init(rootViewController: welcomeVC)
        self.window?.rootViewController = navigation
        //
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return .portrait
    }

}

