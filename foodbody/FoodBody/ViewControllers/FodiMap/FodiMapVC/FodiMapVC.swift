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
import GooglePlaces
import Kingfisher

class FodiMapVC: BaseVC,CLLocationManagerDelegate{
    //MARK: IBOutlet.
    @IBOutlet weak var btnAdd: FoodBodyButton!
    @IBOutlet weak var googleMapView:GMSMapView!
    @IBOutlet weak var clvFodi:UICollectionView!
    @IBOutlet weak var viEdit:UIView!
    @IBOutlet weak var btnEdit: UIButton!
    
    //MARK: variable.
    var locationManager:CLLocationManager? = nil;
    var currentLocation:CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    var listRestaurant: [QueryDocumentSnapshot] = []
    let db = Firestore.firestore()
    
    // MARK: cycle view.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    //MARK:init.
    func initUI(){
        
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
        self.googleMapView.delegate = self;
        self.viEdit.layer.cornerRadius = 22;
        self.viEdit.layer.masksToBounds = true;
        
    }
    
    func initData(){
        self.getDataRestaurant()
    }
    
    func getDataRestaurant() {
        listRestaurant.removeAll()
        FoodbodyUtils.shared.showLoadingHub(viewController: self)
    
        let geohashCenter:String = Geohash.encode(latitude: self.currentLocation.latitude, longitude: self.currentLocation.longitude, 5)
        
        guard let listNeighbors: [String] = Geohash.neighbors(geohashCenter) else {
            return
        }
        
        self.queryLocation(geoHash: geohashCenter, db: db)
        if listNeighbors.count == 8 {
            self.queryLocation(geoHash: listNeighbors[0], db: db)
            self.queryLocation(geoHash: listNeighbors[2], db: db)
            self.queryLocation(geoHash: listNeighbors[4], db: db)
            self.queryLocation(geoHash: listNeighbors[6], db: db)
           
        }
        FoodbodyUtils.shared.hideLoadingHub(viewController: self)

    }
    
    func addListenerOnRestaurantd(db:Firestore) -> Void {
        db.collection("restaurants")
            .addSnapshotListener { querySnapshot, error in
                
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                print(FbConstants.FoodbodiLog, "Listener On Restauran")
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
                print(  querySnapshot!.documents.count);
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
            let type = FoodbodyUtils.shared.checkDataString(dict: dict, key: "type")
            if type == "FOOD_TRUCK" {
                marker.icon = UIImage.init(named: "ic_truck_low")
            }else{
                marker.icon = UIImage.init(named: "ic_restaurant_caloHigh")
            }
            marker.map = googleMapView
        }
    
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationValue: CLLocationCoordinate2D = manager.location?.coordinate {
            self.currentLocation = locationValue;
            print(FbConstants.FoodbodiLog, (currentLocation))
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
            let addRestaurantVC = getViewController(className: AddRestaurantVC.className, storyboard: FbConstants.FodiMapSB) as! AddRestaurantVC;
            addRestaurantVC.delegate = self;
            self.navigationController?.pushViewController(addRestaurantVC, animated: true)
        }
    }
    @IBAction func editAction(sender:UIButton){
        let alert = UIAlertController(title:nil, message: "음식점을 등록할려면 사업자 정보가 필요합니다.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
            // It will dismiss action sheet
        }
        let action = UIAlertAction(title: "Input", style: .default) {
            UIAlertAction in
            //go to company information.
            let companyInfoVC = CompanyInfoVC.init(nibName: "CompanyInfoVC", bundle: nil)
            self.navigationController?.pushViewController(companyInfoVC, animated: true)
            
        }
        alert.addAction(action)
         alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FodiMapCell", for: indexPath) as! FodiMapCell
        
        
        let object: QueryDocumentSnapshot = listRestaurant[indexPath.row]
        let dict: [String: Any] = object.data()
        cell.bindData(dic: dict)
        return cell;
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat = 200;
        let width:CGFloat = self.clvFodi.frame.size.width/3.0;
        let size:CGSize = CGSize.init(width: width, height: height);
        return size;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object:QueryDocumentSnapshot = listRestaurant[indexPath.row];
        let vc:RestaurantInfoMenuVC = getViewController(className: RestaurantInfoMenuVC.className, storyboard: FbConstants.FodiMapSB) as! RestaurantInfoMenuVC
        vc.document = object;
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FodiMapVC:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return nil;
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("test")
        for object in self.listRestaurant{
            let dict:NSDictionary = object.data() as NSDictionary;
            let lat = FoodbodyUtils.shared.checkDataFloat(dict: dict, key: "lat")
            let lng = FoodbodyUtils.shared.checkDataFloat(dict: dict, key: "lng")
            if (marker.position.latitude == lat &&  marker.position.longitude == lng) {
                let vc:RestaurantInfoMenuVC = getViewController(className: RestaurantInfoMenuVC.className, storyboard: FbConstants.FodiMapSB) as! RestaurantInfoMenuVC
                vc.document = object;
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension FodiMapVC:AddRestaurantVCDelegate{
    func addRestaurantSuccessful(sender: AddRestaurantVC) {
        self.getDataRestaurant();
    }
}

