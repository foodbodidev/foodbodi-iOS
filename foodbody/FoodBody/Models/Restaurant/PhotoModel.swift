//
//  PhotoModel.swift
//  FoodBody
//
//  Created by Vuong Toan Chung on 7/16/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation
import ObjectMapper


class PhotoModel: Mappable  {
	
	var mediaLink: String = ""
	
	required init?(map: Map) {
		
	}
	
	init() {
		
	}
	
	func mapping(map: Map) {
		mediaLink <- map["data.mediaLink"]
	}
	
}

