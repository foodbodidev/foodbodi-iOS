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
    var locationManager:CLLocationManager? = nil;
    var currentLocation:CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    var listRestaurant: [QueryDocumentSnapshot] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // For use in foreground
        locationManager = CLLocationManager();
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
        self.clvFodi.delegate = self;
        self.clvFodi.dataSource = self;
    }
    //MARK:init Data
    func getDataRestaurant() -> Void {
        listRestaurant.removeAll()
        FoodbodyUtils.shared.showLoadingHub(viewController: self);
    
        let geohashCenter:String = Geohash.encode(latitude: self.currentLocation.latitude, longitude: self.currentLocation.longitude, 5);
        let listNeighbors:NSArray = Geohash.neighbors(geohashCenter)! as NSArray;
        self.queryLocation(geoHash: geohashCenter, db: db);
        if listNeighbors.count == 8 {
            self.queryLocation(geoHash: listNeighbors[0] as! String, db: db);
            self.queryLocation(geoHash: listNeighbors[2] as! String, db: db);
            self.queryLocation(geoHash: listNeighbors[4] as! String, db: db);
            self.queryLocation(geoHash: listNeighbors[6] as! String, db: db);
            FoodbodyUtils.shared.hideLoadingHub(viewController: self);
        }else{
            FoodbodyUtils.shared.hideLoadingHub(viewController: self);
        }
    }
    func addListenerOnRestaurantd(db:Firestore) -> Void {
        db.collection("restaurants")
            .addSnapshotListener { querySnapshot, error in
                
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                self.replaceDocument(documents: documents)
                self.clvFodi.reloadData()
                self.showDataOnMapWithCurrentLocation(curentLocation: self.currentLocation)
        }
    }
    
    // find replace document in listRestaurant
    func replaceDocument(documents: [QueryDocumentSnapshot]) {
        if self.listRestaurant.count > 0 {
            for i in 0...self.listRestaurant.count - 1 {
                for j in 0...documents.count - 1 {
                    if documents[j].documentID == self.listRestaurant[i].documentID {
                        self.listRestaurant[i] = documents[j]
                    }
                }
            }
        }
    }
    
    func queryLocation(geoHash:String, db:Firestore) -> Void {
        
        db.collection("restaurants").whereField("geohash", isEqualTo: geoHash).getDocuments() { (querySnapshot, err) in
            if let err = err {
               FoodbodyUtils.shared.hideLoadingHub(viewController: self);
                self.alertMessage(message: "Error getting documents \(err.localizedDescription)")
            } else {
                print("Toan12520447",  querySnapshot!.documents.count);
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.listRestaurant.append(document)
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
       
        for object in listRestaurant {
            let dict:NSDictionary = object.data() as NSDictionary;
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: FoodbodyUtils.shared.checkDataFloat(dict: dict, key: "lat"), longitude: FoodbodyUtils.shared.checkDataFloat(dict: dict, key: "lng"));
            marker.title = FoodbodyUtils.shared.checkDataString(dict: dict, key: "name");
            marker.snippet = FoodbodyUtils.shared.checkDataString(dict: dict, key: "address");
            marker.icon = UIImage.init(named: "ic_restaurant_caloHigh")
            marker.map = googleMapView
        }
    
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationValue: CLLocationCoordinate2D = manager.location?.coordinate {
            self.currentLocation = locationValue;
            print("Toan12520447 call, \(currentLocation)")
            self.getDataRestaurant();
            self.addListenerOnRestaurantd(db: self.db)
            locationManager?.stopUpdatingLocation();
            locationManager = nil;
        }
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
        let object:QueryDocumentSnapshot = listRestaurant[indexPath.row] as! QueryDocumentSnapshot;
        let dict:NSDictionary = object.data() as NSDictionary;
        cell.lblName.text = FoodbodyUtils.shared.checkDataString(dict: dict, key: "name");
        cell.lblCategory.text = FoodbodyUtils.shared.checkDataString(dict: dict, key: "category");
        cell.lblKcal.text = "300kcal";
        cell.lblTime.text = FoodbodyUtils.shared.checkDataString(dict: dict, key: "open_hour") + "-" + FoodbodyUtils.shared.checkDataString(dict: dict, key: "close_hour");
        
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat = 150;
        let width:CGFloat = self.clvFodi.frame.size.width/3.0;
        let size:CGSize = CGSize.init(width: width, height: height);
        return size;
    }
}
