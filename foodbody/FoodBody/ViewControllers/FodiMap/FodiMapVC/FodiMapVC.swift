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

class FodiMapVC: BaseVC,CLLocationManagerDelegate {
    @IBOutlet weak var btnAdd: FoodBodyButton!
    @IBOutlet weak var googleMapView:GMSMapView!
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    var listRestaurant:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // For use in foreground
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    //MARK:init Data
    func getDataRestaurant() -> Void {
        let db = Firestore.firestore()
        self.showLoading();
        db.collection("restaurants").getDocuments() { (querySnapshot, err) in
            self.hideLoading()
            if let err = err {
                self.alertMessage(message: "Error getting documents \(err.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let restaurant = RestaurantModel();
                    let dict:NSDictionary = document.data() as NSDictionary;
                    restaurant.address = dict.object(forKey: "address") as! String;
                    restaurant.category = dict.object(forKey: "category") as! String;
                     restaurant.name = dict.object(forKey: "name") as! String;
                    restaurant.lat = dict.object(forKey: "lat") as! Double;
                    restaurant.lng = dict.object(forKey: "lng") as! Double;
                    restaurant.creator = dict.object(forKey: "creator") as! String;
                    restaurant.open_hour = dict.object(forKey: "open_hour") as! String;
                    self.listRestaurant.add(restaurant);
                }
                self.showDataOnMapWithCurrentLocation(curentLocation: self.currentLocation)
            }
        }
    }
    func showDataOnMapWithCurrentLocation(curentLocation:CLLocationCoordinate2D) -> Void {
        let camera = GMSCameraPosition.camera(withLatitude: curentLocation.latitude, longitude: curentLocation.longitude, zoom: 15.0)
        googleMapView.camera = camera
        // Creates a marker in the center of the map.
        listRestaurant.enumerateObjects { (object, index, isStop) in
            
            if let object = object as? RestaurantModel {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: object.lat, longitude: object.lng)
                marker.title = object.name
                marker.snippet = object.address
                marker.icon = UIImage.init(named: "ic_restaurant_caloHigh")
                marker.map = googleMapView
            }
           
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.currentLocation = locationValue;
        self.getDataRestaurant();
        
        manager.stopUpdatingLocation();
        
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
