//
//  RequestService.swift
//  FoodBody
//
//  Created by Phuoc on 6/18/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum RequestService {
    case login(dic: [String: Any])
    case signup(dic: [String: Any])
    case googleSignIn(dict: [String: Any])
    case facbookSignIn(dic: [String: Any])
    case getProfile
    case updateUserProfile(dic: [String: Any])
    case createRestaurant(dic: [String: Any])
    case getCagegory
	case uploadPhoto(dic: Moya.MultipartFormData)
    case getFoodWithRestaurantId(id: String)
    case addComment(dic: [String: Any])
    case updateRestaurant(model: RestaurantRequest)
    case getRestaurantWithProfile
    case getMyRestaurant
    case addFood(dic: [String: Any])
    case deleteFood(model: FoodModel)
    case addReservation(dic: [String: Any])
}

extension RequestService: TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: APIConstant.BASE_URL)!
        }
    }
    

    var path: String {
        switch self {
        case .signup:
            return APIConstant.signup
        case .login:
            return APIConstant.login
        case .googleSignIn:
            return APIConstant.googleSignIn
        case .facbookSignIn:
            return APIConstant.facebookSignIn
        case .getProfile:
            return APIConstant.getProfile
        case .updateUserProfile:
            return APIConstant.updateUserProfile
        case .createRestaurant:
            return APIConstant.createRestaurant
        case .getCagegory:
            return APIConstant.getCategory
		case .uploadPhoto:
			return APIConstant.uploadPhoto
        case .getFoodWithRestaurantId(let id):
            return APIConstant.getFoodWithRestaurantId + "/\(id)" + "/foods"
        case .updateRestaurant:
			if let resID = AppManager.user?.restaurantId, !resID.isEmpty {
				return APIConstant.updateRestaurant + "/\(resID)"
			} else {
				return APIConstant.updateRestaurant
			}
			
        case .addComment:
            return APIConstant.addComment
        case .getRestaurantWithProfile:
            return APIConstant.getRestaurantWithProfile
        case .getMyRestaurant:
            return APIConstant.getMyRestaurant
        case .addFood:
            return APIConstant.addFood
        case .deleteFood(let foodModel):
            return APIConstant.deleteFood + "/" + foodModel.id
        case .addReservation:
            return APIConstant.addReservation;
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signup,
             .login,
             .googleSignIn,
             .facbookSignIn,
             .updateUserProfile,
             .createRestaurant,
			 .uploadPhoto,
             .addFood,
             .addComment,
             .addReservation:
            return .post
        case .updateRestaurant:
            return .put
        case .deleteFood:
            return .delete
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
    
    var headers: [String: String]? {
        
        switch self {
        case .login, .signup, .googleSignIn, .facbookSignIn, .getCagegory:
            return ["Content-Type": "application/json"]
        default:
            return ["Content-Type": "application/json",
                    "Token": AppManager.user?.token ?? ""]
        }
    }
    
    
    var task: Task {
        switch self {
        case .signup(let dic):
            return .requestParameters(parameters: dic, encoding: JSONEncoding.default)
        case .login(let dic):
            return .requestParameters(parameters: dic, encoding: JSONEncoding.default)
        case .googleSignIn(let dic):
            return .requestParameters(parameters: dic, encoding: JSONEncoding.default)
        case .facbookSignIn(let dic):
            return .requestParameters(parameters: dic, encoding: JSONEncoding.default)
        case .updateUserProfile(let dic):
            return .requestParameters(parameters: dic, encoding: JSONEncoding.default)
        case .createRestaurant(let dic):
            return .requestParameters(parameters: dic, encoding: JSONEncoding.default)
		case .uploadPhoto(let mutipartForm):
			return .uploadMultipart([mutipartForm])
        case .addComment(let dic):
            return .requestParameters(parameters: dic, encoding: JSONEncoding.default)
        case .addFood(let dic):
            return .requestParameters(parameters: dic, encoding: JSONEncoding.default)
        case .updateRestaurant(let model):
            return .requestParameters(parameters: model.toJSON(), encoding: JSONEncoding.default)
        case .getRestaurantWithProfile:
            return .requestParameters(parameters: ["include_restaurant" : "true"], encoding: URLEncoding.queryString)
        case .deleteFood(let foodModel):
            return .requestParameters(parameters: ["restaurant_id": foodModel.restaurant_id], encoding: URLEncoding.queryString)
        case .addReservation(let dic):
        
             return .requestParameters(parameters: dic, encoding: JSONEncoding.default)
        
        default:
            return .requestPlain
        }
    }
}






