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
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var googleMapView:GMSMapView!
    @IBOutlet weak var clvFodi:UICollectionView!
	
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
        if let user = AppManager.user, !user.restaurantId.isEmpty {
            btnAdd.setImage(UIImage.init(named: "ic_edit"), for: .normal)
            btnAdd.setImage(UIImage.init(named: "ic_edit"), for: .highlighted)
            btnAdd.backgroundColor = .white
        } else {
            btnAdd.setImage(UIImage.init(named: "ic_add"), for: .normal)
            btnAdd.setImage(UIImage.init(named: "ic_add"), for: .highlighted)
            btnAdd.backgroundColor = Style.Color.mainGreen
        }
        self.registerNotification();
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

    }
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveUpdateRestaurant(_:)), name: .kFb_update_restaurant, object:nil)
    }
    
    @objc func onDidReceiveUpdateRestaurant(_ notification: Notification)
    {
        print(" fetching documents update ....")
        let querySnapshot = notification.userInfo!["KquerySnapshot"] as! QuerySnapshot;
        if querySnapshot.documents.count > 0 {
            getDataRestaurant()
        }
    }
    
    func getDataRestaurant() {
        let geohashCenter:String = Geohash.encode(latitude: self.currentLocation.latitude, longitude: self.currentLocation.longitude, 5)
        guard let listNeighbors: [String] = Geohash.neighbors(geohashCenter) else {
            return
        }
        var listCenter:NSArray = NSArray.init();
        var listZero:NSArray = NSArray.init();
        var listTwo:NSArray = NSArray.init();
        var listFour:NSArray = NSArray.init();
        var listSix:NSArray = NSArray.init();
        FoodbodyUtils.shared.showLoadingHub(viewController: self)
        db.collection("restaurants").whereField("geohash", isEqualTo: geohashCenter).getDocuments() { (querySnapshot, err) in
            if let err = err {
                FoodbodyUtils.shared.hideLoadingHub(viewController: self);
                self.alertMessage(message: "Error getting documents \(err.localizedDescription)")
            } else {
                if let querySnapshot = querySnapshot {
                    listCenter = self.insertDataIntoListFodiMap(querySnapshot: querySnapshot)
                }
                //0
                self.db.collection("restaurants").whereField("geohash", isEqualTo: listNeighbors[0]).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        FoodbodyUtils.shared.hideLoadingHub(viewController: self);
                        self.alertMessage(message: "Error getting documents \(err.localizedDescription)")
                    } else {
                        if let querySnapshot = querySnapshot {
                            listZero = self.insertDataIntoListFodiMap(querySnapshot: querySnapshot)
                        }
                        //2
                        self.db.collection("restaurants").whereField("geohash", isEqualTo: listNeighbors[2]).getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                FoodbodyUtils.shared.hideLoadingHub(viewController: self);
                                self.alertMessage(message: "Error getting documents \(err.localizedDescription)")
                            } else {
                                if let querySnapshot = querySnapshot {
                                    listTwo = self.insertDataIntoListFodiMap(querySnapshot: querySnapshot)
                                }
                                //4
                                self.db.collection("restaurants").whereField("geohash", isEqualTo: listNeighbors[4]).getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        FoodbodyUtils.shared.hideLoadingHub(viewController: self);
                                        self.alertMessage(message: "Error getting documents \(err.localizedDescription)")
                                    } else {
                                        if let querySnapshot = querySnapshot {
                                           listFour = self.insertDataIntoListFodiMap(querySnapshot: querySnapshot)
                                        }
                                        //6
                                        self.db.collection("restaurants").whereField("geohash", isEqualTo: listNeighbors[6]).getDocuments() { (querySnapshot, err) in
                                            if let err = err {
                                                FoodbodyUtils.shared.hideLoadingHub(viewController: self);
                                                self.alertMessage(message: "Error getting documents \(err.localizedDescription)")
                                            } else {
                                                FoodbodyUtils.shared.hideLoadingHub(viewController: self);
                                                self.listRestaurant.removeAll();
                                                if let querySnapshot = querySnapshot {
                                                   listSix = self.insertDataIntoListFodiMap(querySnapshot: querySnapshot)
                                                }
                                                if listCenter.count > 0 {
                                                    for obj in listCenter{
                                                        self.listRestaurant.append(obj as! QueryDocumentSnapshot);
                                                    }
                                                }
                                                if listZero.count > 0 {
                                                    for obj in listZero{
                                                        self.listRestaurant.append(obj as! QueryDocumentSnapshot);
                                                    }
                                                }
                                                if listTwo.count > 0 {
                                                    for obj in listTwo{
                                                        self.listRestaurant.append(obj as! QueryDocumentSnapshot);
                                                    }
                                                }
                                                if listFour.count > 0 {
                                                    for obj in listFour{
                                                        self.listRestaurant.append(obj as! QueryDocumentSnapshot);
                                                    }
                                                }
                                                if listSix.count > 0 {
                                                    for obj in listSix{
                                                        self.listRestaurant.append(obj as! QueryDocumentSnapshot);
                                                    }
                                                }
                                                
                                                self.showDataOnMapWithCurrentLocation(curentLocation: self.currentLocation)
                                                
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    func insertDataIntoListFodiMap(querySnapshot:QuerySnapshot) -> NSMutableArray {
        let listCenter:NSMutableArray = NSMutableArray.init();
        if querySnapshot.documents.count > 0 {
            for document in querySnapshot.documents {
                listCenter.add(document);
            }
        }
        return listCenter;
    }
    
    func showDataOnMapWithCurrentLocation(curentLocation:CLLocationCoordinate2D) -> Void {
        let camera = GMSCameraPosition.camera(withLatitude: curentLocation.latitude, longitude: curentLocation.longitude, zoom: 15.0)
        googleMapView.camera = camera
        // Creates a marker in the center of the map.
        for object in listRestaurant {
            let dict:NSDictionary = (object as AnyObject).data()! as NSDictionary;
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: FoodbodyUtils.shared.checkDataFloat(dict: dict, key: "lat"), longitude: FoodbodyUtils.shared.checkDataFloat(dict: dict, key: "lng"));
            marker.title = FoodbodyUtils.shared.checkDataString(dict: dict, key: "name");
            marker.snippet = FoodbodyUtils.shared.checkDataString(dict: dict, key: "address");
            let type = FoodbodyUtils.shared.checkDataString(dict: dict, key: "type")
            let listCalos:NSMutableArray? = NSMutableArray.init();
            if let kcals = dict.object(forKey: "calo_values") {
                if (kcals as AnyObject).count > 0 {
                    (kcals as AnyObject).enumerateObjects({ object, index, stop in
                        listCalos?.add(object);
                    })
                }
            }
            let averageCalo:Double = self.averageCalo(listCalosData: listCalos!);
            if type == "FOOD_TRUCK" {
                if averageCalo < FbConstants.lowCalo {
                    marker.icon = UIImage.init(named: "ic_truck_low")
                }
                if averageCalo >= FbConstants.lowCalo && averageCalo < FbConstants.highCalo {
                    marker.icon = UIImage.init(named: "ic_truck_medium")
                }
                if averageCalo >= FbConstants.highCalo {
                    marker.icon = UIImage.init(named: "ic_truck_high")
                }
            }else{
                if averageCalo < FbConstants.lowCalo {
                    marker.icon = UIImage.init(named: "ic_restaurant_caloLow")
                }
                if averageCalo >= FbConstants.lowCalo && averageCalo < FbConstants.highCalo {
                    marker.icon = UIImage.init(named: "ic_restaurant_caloMedium")
                }
                if averageCalo >= FbConstants.highCalo {
                    marker.icon = UIImage.init(named: "ic_restaurant_caloHigh")
                }
            }
            marker.map = googleMapView
            self.clvFodi.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationValue: CLLocationCoordinate2D = manager.location?.coordinate {
            self.currentLocation = locationValue;
            print(FbConstants.FoodbodiLog, (currentLocation))
            self.getDataRestaurant();
            locationManager?.stopUpdatingLocation();
            locationManager = nil;
        }
    }
    //MARK: action.
    
    @IBAction func addAction(sender:UIButton){
		
		if let user = AppManager.user {
			if user.restaurantId.isEmpty { // need to input company infor
				popupNotifyInputInfo()
			} else {
				let addRestaurantVC = getViewController(className: AddRestaurantVC.className, storyboard: FbConstants.FodiMapSB) as! AddRestaurantVC;
				self.navigationController?.pushViewController(addRestaurantVC, animated: true)
			}
			
		} else {
			let registerAccountVC = getViewController(className: RegisterAccountVC.className, storyboard: FbConstants.AuthenticationSB) as! RegisterAccountVC
			let nav = UINavigationController.init(rootViewController: registerAccountVC);
			self.present(nav, animated: true, completion: nil)
		}
    }
	
    private func popupNotifyInputInfo(){
        let alert = UIAlertController(title:nil, message: "Business information is required to register a restaurant", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
            // It will dismiss action sheet
        }
        let action = UIAlertAction(title: "Input", style: .default) {
            UIAlertAction in
            //go to company information.
            let companyInfoVC = getViewController(className: CompanyInfoVC.className, storyboard: FbConstants.FodiMapSB)
            self.navigationController?.pushViewController(companyInfoVC, animated: true)
            
        }
        alert.addAction(action)
		alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: others method.
    func averageCalo(listCalosData:NSArray) -> Double {
        if (listCalosData.count) > 0 {
            var sum:Double = 0.0;
            for i in 0...listCalosData.count - 1 {
                let value:Double = listCalosData[i] as! Double;
                sum = sum + value;
            }
            let averageCalo:Double = sum/Double(listCalosData.count);
            return averageCalo;
        }else{
            return 0;
        }
    }
}

extension FodiMapVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        cell.lblName.text = dict["name"] as? String
        cell.lblCategory.text = dict["category"] as? String
        let listCalos:NSMutableArray? = NSMutableArray.init();
        if let kcals = dict["calo_values"] {
            if (kcals as AnyObject).count > 0 {
                (kcals as AnyObject).enumerateObjects({ object, index, stop in
                    listCalos?.add(object);
                })
            }
        }
        let averageCalo:Double = self.averageCalo(listCalosData: listCalos!);
        cell.lblKcal.text = String(format: "%.f", averageCalo);
        if let openTime = dict["open_hour"] as? String,
            let closeTime = dict["open_hour"] as? String{
            cell.lblTime.text =   openTime + "~" + closeTime
        }
        
        if let imageUrl = URL(string: dict["photo"] as? String ?? "") {
            cell.imvRestaurant.kf.setImage(with: imageUrl, placeholder: nil)
        }
        return cell;
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat = 150;
        let width:CGFloat = self.clvFodi.frame.size.width*0.4
        let size:CGSize = CGSize.init(width: width, height: height);
        return size;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object:QueryDocumentSnapshot = listRestaurant[indexPath.row];
        let vc:RestaurantInfoMenuVC = getViewController(className: RestaurantInfoMenuVC.className, storyboard: FbConstants.FodiMapSB) as! RestaurantInfoMenuVC
        vc.document = object;
        self.navigationController?.pushViewController(vc, animated: true)
    }
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 8
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 8
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
	}
	
	
}

extension FodiMapVC:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return nil;
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        for object in self.listRestaurant{
            let dict:NSDictionary = (object as AnyObject).data()! as NSDictionary;
            let lat = FoodbodyUtils.shared.checkDataFloat(dict: dict, key: "lat")
            let lng = FoodbodyUtils.shared.checkDataFloat(dict: dict, key: "lng")
            if (marker.position.latitude == lat &&  marker.position.longitude == lng) {
                let vc:RestaurantInfoMenuVC = getViewController(className: RestaurantInfoMenuVC.className, storyboard: FbConstants.FodiMapSB) as! RestaurantInfoMenuVC
                vc.document = object;
                self.navigationController?.pushViewController(vc, animated: true)
                return;
            }
        }
    }
    
}



