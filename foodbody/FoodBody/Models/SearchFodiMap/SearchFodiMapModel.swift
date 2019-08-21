//
//  SearchFodiMapModel.swift
//  FoodBody
//
//  Created by Toan Tran on 8/21/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import ObjectMapper
class SearchFodiMapModel: Mappable {
    var word: String = ""
    var document_id: String = ""
    var kind: String = ""
    var position: String = ""
    var id: String = ""
    var document: DocumentModel = DocumentModel()
    var isSuccess: Bool = false
    var status_code: Int = -1
    var message: String = ""
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        word <- map["data.word"]
        document_id <- map["data.document_id"]
        kind <- map["data.kind"]
        position <- map["data.position"]
        id <- map["data.id"]
        document <- map["data.document"]
        message <- map["message"]
        isSuccess = (status_code == 0) ? true : false
    }
}
