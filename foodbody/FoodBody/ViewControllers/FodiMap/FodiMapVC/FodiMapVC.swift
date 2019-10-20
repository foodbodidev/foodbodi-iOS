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

class FodiMapVC: BaseVC,UITextFieldDelegate,SearchFodiMapVCDelegate{
    //MARK: IBOutlet.
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var googleMapView:GMSMapView!
    @IBOutlet weak var clvFodi:UICollectionView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var viSearch: UIView!
    
    //MARK: variable.
    var listRestaurant: [QueryDocumentSnapshot] = []
    
    let db = Firestore.firestore()
    
    // MARK: cycle view.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.getDataRestaurant();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true;
        if AppManager.user != nil, AppManager.restaurant != nil {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        if CLLocationManager .authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined{
             self.alertMessage(message: "Please visit your device settings to enable location permissions.");
        }
    }
    
    //MARK:init.
    func initUI(){
        tfSearch.delegate = self
        tfSearch.placeholder = "Search restaurant, food, ...."
        self.clvFodi.delegate = self;
        self.clvFodi.dataSource = self;
        self.googleMapView.delegate = self;
        self.title = "FodiMap";
        self.viSearch.layer.cornerRadius = 8;
        self.viSearch.layer.borderColor = UIColor.backgroundGray().cgColor;
        self.viSearch.layer.borderWidth = 1;
    }
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveUpdateRestaurant(_:)), name: .kFb_update_restaurant, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getDataRestaurant), name:.kFB_update_restaurant_when_enable_location , object:nil);
    }
    
    @objc func onDidReceiveUpdateRestaurant(_ notification: Notification)
    {
        print(" fetching documents update ....")
        let querySnapshot = notification.userInfo!["KquerySnapshot"] as! QuerySnapshot;
        if querySnapshot.documents.count > 0 {
            if  FBAppDelegate.currentLocation.latitude > 0 &&  FBAppDelegate.currentLocation.longitude > 0{
                getDataRestaurant()
            }
        }
    }
    
    @objc func getDataRestaurant() {
        let geohashCenter:String = Geohash.encode(latitude: FBAppDelegate.currentLocation.latitude, longitude: FBAppDelegate.currentLocation.longitude, 5)
        var listCenter:NSArray = NSArray.init();
        FoodbodyUtils.shared.showLoadingHub(viewController: self)
        db.collection("restaurants").whereField("neighbour_geohash", arrayContains: geohashCenter).whereField("license.status", isEqualTo:"APPROVED").getDocuments() { (querySnapshot, err) in
            FoodbodyUtils.shared.hideLoadingHub(viewController: self);
            if let err = err {
                self.alertMessage(message: "Error getting documents \(err.localizedDescription)")
            } else {
                if let querySnapshot = querySnapshot {
                    listCenter = self.insertDataIntoListFodiMap(querySnapshot: querySnapshot)
                    var listData: [QueryDocumentSnapshot] = [];
                    if listCenter.count > 0 {
                        for obj in listCenter{
                            listData.append(obj as! QueryDocumentSnapshot);
                        }
                    }
                    if listData.count > 0 {
                        self.listRestaurant.removeAll();
                        for obj in listData {
                            self.listRestaurant.append(obj);
                        }
                        self.clvFodi.reloadData()
                        self.showDataOnMapWithCurrentLocation(curentLocation: FBAppDelegate.currentLocation)
                        
                    }else{
                        self.showDataOnMapWithCurrentLocation(curentLocation: FBAppDelegate.currentLocation)
                    }
                    print(FbConstants.FoodbodiLog, "number count \(self.listRestaurant.count)")
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
        googleMapView.clear()
        
        //Add current location on mapView.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D.init(latitude: curentLocation.latitude, longitude: curentLocation.longitude);
         marker.icon = UIImage.init(named: "ic_location")
        marker.map = googleMapView;
        
        // Creates a marker in the center of the map.
        for object in self.listRestaurant {
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
        }
    }
    //MARK: action.
    
    @IBAction func addAction(sender:UIButton){
		
		if AppManager.user != nil {
			if AppManager.restaurant == nil { // need to input company infor
				popupNotifyInputInfo()
			} else {
				let addRestaurantVC = getViewController(className: AddRestaurantVC.className, storyboard: FbConstants.FodiMapSB) as! AddRestaurantVC;
				self.navigationController?.pushViewController(addRestaurantVC, animated: true)
			}
			
		} else {
			let registerAccountVC = getViewController(className: RegisterAccountVC.className, storyboard: FbConstants.AuthenticationSB) as! RegisterAccountVC
			let nav = UINavigationController.init(rootViewController: registerAccountVC);
            nav.navigationBar.backgroundColor = UIColor.white;
            nav.navigationBar.tintColor = UIColor.white;
			self.present(nav, animated: true, completion: nil)
		}
    }
    @IBAction func currentLocaltionAction(sender:UIButton){
        if FBAppDelegate.currentLocation.longitude == 0 && FBAppDelegate.currentLocation.latitude == 0 {
            return;
        }
        let camera = GMSCameraPosition.camera(withLatitude: FBAppDelegate.currentLocation.latitude, longitude: FBAppDelegate.currentLocation.longitude, zoom: 15.0)
        googleMapView.moveCamera(GMSCameraUpdate.setCamera(camera));
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
    //MARK: UItextFieldDelegate.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let vc:SearchFodiMapVC = getViewController(className: SearchFodiMapVC.className, storyboard: FbConstants.FodiMapSB) as! SearchFodiMapVC;
        vc.delegate = self;
        self.present(vc, animated: true, completion: nil);
        return false;
    }
    func SearchFodiMapVCDelegate(cell: SearchFodiMapVC, obj: String) {
        FoodbodyUtils.shared.showLoadingHub(viewController: self)
        self.db.collection("restaurants").getDocuments { (querySnapshot, error) in
            FoodbodyUtils.shared.hideLoadingHub(viewController: self);
            if let error = error {
                self.alertMessage(message: "Error getting documents \(error.localizedDescription)")
            } else {
                if let querySnapshot = querySnapshot {
                    for item in querySnapshot.documents {
                        if item.documentID == obj {
                            let vc:RestaurantInfoMenuVC = getViewController(className: RestaurantInfoMenuVC.className, storyboard: FbConstants.FodiMapSB) as! RestaurantInfoMenuVC
                            vc.document = item;
                            self.navigationController?.pushViewController(vc, animated: true)
                            break;
                        }
                    }
                    
                }
            }
        }
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
        return self.listRestaurant.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FodiMapCell", for: indexPath) as! FodiMapCell
        
        
        let object: QueryDocumentSnapshot = self.listRestaurant[indexPath.row]
        let dict: [String: Any] = object.data()
        cell.lblName.text = dict["name"] as? String
        if (dict["category"] != nil) {
            let category:String = dict["category"] as! String
            cell.lblCategory.text = getValueFromKey(key: category)
        }
        let listCalos:NSMutableArray? = NSMutableArray.init();
        if let kcals = dict["calo_values"] {
            if (kcals as AnyObject).count > 0 {
                (kcals as AnyObject).enumerateObjects({ object, index, stop in
                    listCalos?.add(object);
                })
            }
        }
        let averageCalo:Double = self.averageCalo(listCalosData: listCalos!);
        if averageCalo > 0{
            cell.lblKcal.text = String(format: "%.0f kcal", averageCalo);
            if averageCalo < FbConstants.lowCalo {
                cell.lblKcal.textColor = UIColor.lowKcalColor()
            }
            if averageCalo >= FbConstants.lowCalo && averageCalo < FbConstants.highCalo {
                cell.lblKcal.textColor = UIColor.mediumKcalColor()
            }
            if averageCalo >= FbConstants.highCalo {
                cell.lblKcal.textColor = UIColor.highKcalColor()
            }
        }
        if let openTime = dict["open_hour"] as? String,
            let closeTime = dict["open_hour"] as? String{
           cell.lblTime.text = openTime + "~" + closeTime
        }
        if (dict["photos"] != nil){
            let listImage:NSArray = dict["photos"] as! NSArray;
            if listImage.count > 0 {
                let sUrl = listImage.firstObject as! String;
                if sUrl.count > 0 {
                  cell.imvRestaurant.setImageWithUrl(url: sUrl)
                }
            }
        }else{
            cell.imvRestaurant.image = UIImage.init(named: "ic_bg");
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
        let object:QueryDocumentSnapshot = self.listRestaurant[indexPath.row];
        if object.documentID.count > 0{
            let vc:RestaurantInfoMenuVC = getViewController(className: RestaurantInfoMenuVC.className, storyboard: FbConstants.FodiMapSB) as! RestaurantInfoMenuVC
            vc.document = object;
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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



