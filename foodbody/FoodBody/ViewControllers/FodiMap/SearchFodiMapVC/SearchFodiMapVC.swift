//
//  SearchFodiMapVC.swift
//  FoodBody
//
//  Created by Toan Tran on 8/19/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class SearchFodiMapVC: BaseVC,UITextFieldDelegate{
    @IBOutlet var tfSearch:UITextField!
    @IBOutlet var tbvSearch:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbvSearch.delegate = self;
        self.tbvSearch.dataSource = self;
        // Do any additional setup after loading the view.
    }
    //MARK UItextFieldDelegate.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfSearch.resignFirstResponder();
        
        return true;
    }

    //MARK action.
    @IBAction func cancelAction() {
        self.dismiss(animated: true, completion: nil);
    }
    @IBAction func searchAction() {
        self.dismiss(animated: true, completion: nil);
        
    }

}

extension SearchFodiMapVC:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell();
    }
}
