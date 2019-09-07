//
//  AddCaloVC.swift
//  FoodBody
//
//  Created by Phuoc on 8/21/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class AddCaloVC: BaseVC,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet var tfSearch:UITextField!
    @IBOutlet var tbvCalos:UITableView!
    
    let app_id:String = "0c28eb30";
    let app_key:String = "4021856d25ff2e35461894dbaed4938a";
    var listDisplay:NSMutableArray = NSMutableArray.init();
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbvCalos.delegate = self;
        self.tbvCalos.dataSource = self;
        self.tfSearch.delegate = self;
        self.tbvCalos.register(UINib.init(nibName: CaloInfoCell.className, bundle: nil), forCellReuseIdentifier: CaloInfoCell.className)
        // Do any additional setup after loading the view.
    }
    //MARK: Action
    @IBAction func onbtnCancelPress(sender:Any){
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func onbtnSavePress(sender:Any){
        self.dismiss(animated: false, completion: nil)
    }
    //MARK: UItextFieldDelegate.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = tfSearch.text {
            if text.count > 0 {
                self.searchDataWithText(text: text);
            }
        }
        return true;
    }
    func searchDataWithText(text:String) {
        
        tfSearch.resignFirstResponder();
        DispatchQueue.main.async{
            FoodbodyUtils.shared.showLoadingHub(viewController: self);
            let sUrl:String = String(format: "https://api.edamam.com/api/food-database/parser?ingr=%@&app_id=%@&app_key=%@", text,self.app_id,self.app_key)
            let task = URLSession.shared.dataTask(with: NSURL(string: sUrl)! as URL, completionHandler: { (data, response, error) -> Void in
                DispatchQueue.main.async{
                     FoodbodyUtils.shared.hideLoadingHub(viewController: self);
                }
                do{
                    let str:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    let listData:NSArray = str.object(forKey: "hints") as! NSArray;
                    listData.enumerateObjects({ (dict, index, stop)  in
                        let food:NSDictionary = (dict as AnyObject).object(forKey: "food") as! NSDictionary
                        let calosData:CalosInfo = CalosInfo.init(dict: food );
                        self.listDisplay.add(calosData);
                    })
                    DispatchQueue.main.async{
                        self.tbvCalos.reloadData();
                    }
                }
                catch {
                    print("json error: \(error)")
                }
            })
            task.resume()
        }
    }
    
    //MARK: UITableview.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDisplay.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CaloInfoCell = tableView.dequeueReusableCell(withIdentifier: "CaloInfoCell", for: indexPath) as! CaloInfoCell;
        let calosData:CalosInfo = self.listDisplay[indexPath.row] as! CalosInfo;
        cell.lblCategory.text = calosData.categoryLabel;
        cell.lblENERC_KCAL.text = String.init(format: "%f kcal", calosData.nutrients.ENERC_KCAL);
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
}
