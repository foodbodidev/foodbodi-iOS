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

class FodiMapVC: UIViewController {
    @IBOutlet weak var btnAdd: FoodBodyButton!
    @IBOutlet weak var googleMapView:GMSMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        googleMapView.camera = camera
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = googleMapView
        //get data
//        self.getDataRestaurant();
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
