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
    //MARK: IBOutlet.
    @IBOutlet weak var btnAdd: FoodBodyButton!
    @IBOutlet weak var googleMapView:GMSMapView!
    @IBOutlet weak var clvFodi:UICollectionView!
    //MARK: variable.
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
        self.clvFodi.delegate = self;
        self.clvFodi.dataSource = self;
    }
    //MARK:init Data
    func getDataRestaurant() -> Void {
        let db = Firestore.firestore()
        listRestaurant.removeAllObjects();
        self.showLoading();
        let geohash:String = Geohash.encode(latitude: self.currentLocation.latitude, longitude: self.currentLocation.longitude, length: 1);
        db.collection("restaurants").whereField("geohash", isEqualTo: geohash).getDocuments() { (querySnapshot, err) in
            self.hideLoading()
            if let err = err {
                self.alertMessage(message: "Error getting documents \(err.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let restaurant = RestaurantModel();
                    let dict:NSDictionary = document.data() as NSDictionary;
                    restaurant.address = FoodbodyUtils.shared.checkDataString(dict: dict, key: "address");
                    restaurant.category = FoodbodyUtils.shared.checkDataString(dict: dict, key: "category");
                     restaurant.name = FoodbodyUtils.shared.checkDataString(dict: dict, key: "name");
                    restaurant.lat = FoodbodyUtils.shared.checkDataFloat(dict: dict, key: "lat");
                    restaurant.lng = FoodbodyUtils.shared.checkDataFloat(dict: dict, key: "lng");
                    restaurant.creator = FoodbodyUtils.shared.checkDataString(dict: dict, key: "creator");
                    restaurant.open_hour = FoodbodyUtils.shared.checkDataString(dict: dict, key: "open_hour");
                    restaurant.close_hour = FoodbodyUtils.shared.checkDataString(dict: dict, key: "close_hour");
                    self.listRestaurant.add(restaurant);
                }
                self.showDataOnMapWithCurrentLocation(curentLocation: self.currentLocation)
                self.clvFodi.reloadData();
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

extension FodiMapVC:UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listRestaurant.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FodiMapCell", for: indexPath) as! FodiMapCell;
        let restaurant:RestaurantModel = listRestaurant[indexPath.row] as! RestaurantModel;
        cell.lblName.text = restaurant.name;
        cell.lblCategory.text = restaurant.category;
        cell.lblKcal.text = "300kcal"
        cell.lblTime.text = restaurant.open_hour + "-" + restaurant.close_hour;
        
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat = 150;
        let width:CGFloat = self.clvFodi.frame.size.width/3.0;
        let size:CGSize = CGSize.init(width: width, height: height);
        return size;
    }
}
