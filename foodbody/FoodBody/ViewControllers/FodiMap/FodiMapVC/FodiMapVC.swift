//
//  FodiMapVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class FodiMapVC: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var btnAdd: FoodBodyButton!
    @IBOutlet weak var googleMapView:GMSMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get data
//        self.getDataRestaurant();
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
//    //MARK: read data from firestore.
//    func getDataRestaurant() -> Void {
//        let db = Firestore.firestore()
//        db.collection("restaurants").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
//    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        manager.stopUpdatingLocation();
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 20.0)
        googleMapView.camera = camera
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 10.800971, longitude: 106.638621)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.icon = UIImage.init(named: "ic_restaurant_caloHigh")
        marker.map = googleMapView

        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: 10.798715, longitude: 106.639136)
        marker2.title = "AAA"
        marker2.snippet = "BBBB"
        marker2.icon = UIImage.init(named: "ic_restaurant_caloLow")
        marker2.map = googleMapView
        
    }
    //MARK: action.
    
    @IBAction func addAction(sender:UIButton){
        
        if AppManager.user?.token == nil { // not login yet
            let registerAccountVC = getViewController(className: RegisterAccountVC.className, storyboard: FbConstants.AuthenticationSB) as! RegisterAccountVC
            let nav = UINavigationController.init(rootViewController: registerAccountVC);
            self.present(nav, animated: true, completion: nil)
            
        } else {
            let addRestaurantVC = getViewController(className: AddRestaurantVC.className, storyboard: FbConstants.FodiMapSB)
            self.navigationController?.pushViewController(addRestaurantVC, animated: true)
            
        }
    }

}
