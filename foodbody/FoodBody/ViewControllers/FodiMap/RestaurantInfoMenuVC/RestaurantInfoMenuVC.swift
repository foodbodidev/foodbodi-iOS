//
//  RestaurantInfoMenuVC.swift
//  FoodBody
//
//  Created by Toan Tran on 7/14/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import Firebase

class RestaurantInfoMenuVC: BaseVC {
    var document:QueryDocumentSnapshot? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if document != nil {
            let dict:NSDictionary = document!.data() as NSDictionary;
            
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
