//
//  SearchFodiMapVC.swift
//  FoodBody
//
//  Created by Toan Tran on 8/19/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class SearchFodiMapVC: BaseVC,UITextFieldDelegate{
    //MARK: IBOutlet.
    @IBOutlet var tfSearch:UITextField!
    @IBOutlet var tbvSearch:UITableView!
    var listDisplay: [SearchFodiMapModel] = []
    //MARK: Cycle view.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbvSearch.delegate = self;
        self.tbvSearch.dataSource = self;
        tfSearch.delegate = self;
    }
    //MARK UItextFieldDelegate.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfSearch.resignFirstResponder();
        if let text = tfSearch.text {
            if text.count > 0 {
                self.searchDataWithText(text: text);
            }
        }
        return true;
    }

    //MARK action.
    @IBAction func cancelAction() {
        self.dismiss(animated: true, completion: nil);
    }
    @IBAction func searchAction() {
        if let text = tfSearch.text {
            if text.count > 0 {
                self.searchDataWithText(text: text);
            }
        }
        
    }
    func searchDataWithText(text:String) {
        self.listDisplay.removeAll();
        FoodbodyUtils.shared.showLoadingHub(viewController: self);
        RequestManager.searchFodiMap(text: text) { (result, error) in
            FoodbodyUtils.shared.hideLoadingHub(viewController: self);
            if let error = error {
                self.alertMessage(message: error.localizedDescription)
            }
            if let result = result {
                
                if result.isSuccess {
                    
                    self.listDisplay = result.data;
                    self.tbvSearch.reloadData();
                } else {
                    self.alertMessage(message: result.message)
                }
            }
        }
    }
}


//MARK: UITableViewDelegate, UITableviewDatasource.

extension SearchFodiMapVC:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listDisplay.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SearchTypeFoodCell = tableView.dequeueReusableCell(withIdentifier: "SearchTypeFoodCell", for: indexPath) as! SearchTypeFoodCell;
        let obj:SearchFodiMapModel = self.listDisplay[indexPath.row];
        cell.lblName.text = obj.document.name;
        cell.lblType.text = obj.kind;
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
}
