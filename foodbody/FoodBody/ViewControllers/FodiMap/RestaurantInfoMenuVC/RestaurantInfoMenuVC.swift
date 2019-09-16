//
//  RestaurantInfoMenuVC.swift
//  FoodBody
//
//  Created by Toan Tran on 7/14/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import INSPhotoGallery

class RestaurantInfoMenuVC: BaseVC,UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: variables
    var document:QueryDocumentSnapshot? = nil
    var listMenu:NSMutableArray?
    var tabMenuVC:TabMenuVC?
    var tabChatVC:TabChatVC?
    weak var navInfoMenu:UINavigationController!
    var listCalos:NSMutableArray = NSMutableArray.init();
    var listImage:NSArray = [];
    
    // MARK: IBOutlet.
    @IBOutlet weak var viContainer: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblKcal: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viButton: UIView!
    @IBOutlet weak var viHeader: UIView!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var clvImage: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI();
        self.initVar();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false;
    }
    //MARK: init.
    func initUI(){
        self.btnCall.layer.cornerRadius = 12;
        self.btnCall.layer.masksToBounds = true;
        self.btnLike.layer.cornerRadius = 22;
        self.btnLike.layer.masksToBounds = true;
        self.viHeader.layer.cornerRadius = 10;
        self.viHeader.layer.masksToBounds = true;
        self.viButton.layer.cornerRadius = 10;
        self.viButton.layer.masksToBounds = true;
        self.viContainer.layer.cornerRadius = 10;
        self.viContainer.layer.masksToBounds = true;
        
        //UICollectionView.
        let layoutClv:UICollectionViewFlowLayout = UICollectionViewFlowLayout();
        layoutClv.scrollDirection = .horizontal;
        layoutClv.minimumLineSpacing = 0;
        layoutClv.minimumInteritemSpacing = 0;
        layoutClv.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0 );
        layoutClv.itemSize = CGSize.init(width: getScreenWidth(), height: 300);
        
        self.clvImage.collectionViewLayout = layoutClv;
        self.clvImage.showsVerticalScrollIndicator = false;
        self.clvImage.showsHorizontalScrollIndicator = false;
        self.clvImage.delegate = self;
        self.clvImage.dataSource = self;
        DispatchQueue.main.async {
            
            self.btnMenu.setTitleColor(Style.Color.mainGreen, for: .normal)
            self.btnChat.setTitleColor(Style.Color.mainGray, for: .normal)
        }
    }
    func initVar() {
        
        if let document = document {
            let dict:NSDictionary = document.data() as NSDictionary;
            self.lblName.text = FoodbodyUtils.shared.checkDataString(dict: dict, key: "name");
            let category = FoodbodyUtils.shared.checkDataString(dict: dict, key: "category");
            self.lblCategory.text = getValueFromKey(key: category)
            if let kcals = dict.object(forKey: "calo_values") {
                if (kcals as AnyObject).count > 0 {
                    (kcals as AnyObject).enumerateObjects({ object, index, stop in
                        listCalos.add(object);
                    })
                }
            }
            if dict.object(forKey: "open_hour") != nil{
                self.lblTime.text = FoodbodyUtils.shared.checkDataString(dict: dict, key: "open_hour") + "~" + FoodbodyUtils.shared.checkDataString(dict: dict, key: "close_hour");
            }else{
                //nothing to do.
            }
            self.tabMenuVC!.idRestaurant = document.documentID;
            self.navInfoMenu.setViewControllers([self.tabMenuVC!], animated: false);
            if (dict["photos"] != nil){
                 listImage = dict["photos"] as! NSArray
            }
            self.clvImage.reloadData();
        }
        if (listCalos.count) > 0 {
            let averageCalo:Double = self.averageCalo(listCalosData: listCalos);
            self.lblKcal.text = String(format: "%.0f kcal",averageCalo);
            if averageCalo < FbConstants.lowCalo {
                self.lblKcal.textColor = UIColor.lowKcalColor()
            }
            if averageCalo >= FbConstants.lowCalo && averageCalo < FbConstants.highCalo {
                self.lblKcal.textColor = UIColor.mediumKcalColor()
            }
            if averageCalo >= FbConstants.highCalo {
                self.lblKcal.textColor = UIColor.highKcalColor()
            }
        }
    }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nav_info_menu" {
            self.navInfoMenu = (segue.destination as! UINavigationController)
            self.navInfoMenu.navigationBar.isHidden = true;
            self.tabMenuVC = getViewController(className: TabMenuVC.className, storyboard: FbConstants.FodiMapSB) as? TabMenuVC
            self.tabChatVC = getViewController(className: TabChatVC.className, storyboard: FbConstants.FodiMapSB) as? TabChatVC
        }
    }
    //MARK: action
    @IBAction func menuAction(sender:UIButton){
        DispatchQueue.main.async {
            
            self.btnMenu.setTitleColor(Style.Color.mainGreen, for: .normal)
            self.btnChat.setTitleColor(Style.Color.mainGray, for: .normal)
        }
        self.navInfoMenu.setViewControllers([self.tabMenuVC!], animated: false)
    }
    @IBAction func chatAction(sender:UIButton){
        DispatchQueue.main.async {
            
            self.btnChat.setTitleColor(Style.Color.mainGreen, for: .normal)
            self.btnMenu.setTitleColor(Style.Color.mainGray, for: .normal)
        }
         if let document = document {
            self.tabChatVC!.restaurantId = document.documentID;
            let dict:NSDictionary = document.data() as NSDictionary;
            self.tabChatVC!.creatorRestaurant = FoodbodyUtils.shared.checkDataString(dict: dict, key: "creator");
        }
        self.navInfoMenu.setViewControllers([self.tabChatVC!], animated: false);
    }
    //MARK: UICollectionView.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:ImageRestaurantInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageRestaurantInfoCell", for: indexPath) as! ImageRestaurantInfoCell;
       
        let sUrl:String = listImage[indexPath.row] as! String;
        if let url = URL.init(string: sUrl) {
            cell.imgRestaurant.kf.setImage(with: url)
        } else {
            cell.imgRestaurant.image = nil
        }
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sUrl:String = listImage[indexPath.row] as! String;
        let headerPhoto: [INSPhotoViewable] = {
            return [
                INSPhoto(imageURL: URL.init(string: sUrl), thumbnailImage: nil)
            ]
        }()
        let galleryPreview = INSPhotosViewController(photos: headerPhoto, initialPhoto: headerPhoto.first, referenceView: self.view)
        present(galleryPreview, animated: true, completion: nil)
    }

}
