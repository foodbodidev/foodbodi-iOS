//
//  RequestManager.swift
//  FoodBody
//
//  Created by Phuoc on 6/18/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation



import Foundation
import Moya
import Alamofire
import ObjectMapper


let manager = Manager(
    configuration: URLSessionConfiguration.default,
    serverTrustPolicyManager: CustomServerTrustPoliceManager())

let provider = MoyaProvider<RequestService>(manager: manager, plugins: [NetworkLoggerPlugin(verbose: true)])

//let provider = MoyaProvider<RequestService>()

class CustomServerTrustPoliceManager: ServerTrustPolicyManager {
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return .disableEvaluation
    }
    
    public init() {
        super.init(policies: [:])
    }
}


struct RequestManager {
    //register
    static func registerWithUserInfo(request: UserRequest, completion: @escaping (_ result: ResonseModel?, _ error: Error?) -> ()) {
        
        provider.request(.signup(dic: request.toJSON())) { result in 
            do {
                switch result {
                case .success(let response):
                    let json = try response.mapJSON()
                    print(String(describing: response.request))
                    print(String(describing: json))
                    let response = Mapper<ResonseModel>().map(JSONObject:json)
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                    print(error)
                }
            } catch let error {
                completion(nil, error)
                print(error)
            }
        }
    }
    //Login.
    static func loginWithUserInfo(request: UserRequest, completion: @escaping (_ result: User?, _ error: Error?) -> ()) {
        
        provider.request(.login(dic: request.toJSON())) { result in
            do {
                switch result {
                case .success(let response):
                    let json = try response.mapJSON()
                    print(String(describing: response.request))
                    print(String(describing: json))
                    let response = Mapper<User>().map(JSONObject:json)
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                    print(error)
                }
            } catch let error {
                completion(nil, error)
                print(error)
            }
        }
    }
    //Google signin.
    static func googleSignInWithToken(request:String, completion: @escaping (_ result: User?, _ error: Error?) -> ()){
        
        let parameter = ["google_id_token": request]
        provider.request(.googleSignIn(dict:parameter as [String : Any])) { result in
            do {
                switch result {
                case .success(let response):
                    let json = try response.mapJSON()
                    print(String(describing: response.request))
                    print(String(describing: json))
                    let response = Mapper<User>().map(JSONObject:json)
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                    print(error)
                }
            } catch let error {
                completion(nil, error)
                print(error)
            }
        }
    }
    
    //Facebook signin.
    static func faceBookSignIn(request: UserRequest, completion: @escaping (_ result: User?, _ error: Error?) -> ()){
        
        print(request.toJSON())

        provider.request(.facbookSignIn(dic: request.toJSON())) { result in
            do {
                switch result {
                case .success(let response):
                    let json = try response.mapJSON()
                    print(String(describing: response.request))
                    print(String(describing: json))
                    let response = Mapper<User>().map(JSONObject:json)
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                    print(error)
                }
            } catch let error {
                completion(nil, error)
                print(error)
            }
        }
    }
    //Get Profile.
    static func getProfile(completion: @escaping (_ result: UserProfile?, _ error: Error?) -> ()){
        

        provider.request(.getProfile) { result in
            do {
                switch result {
                case .success(let response):
                    let json = try response.mapJSON()
                    print(String(describing: response.request))
                    print(String(describing: json))
                    let response = Mapper<UserProfile>().map(JSONObject:json)
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                    print(error)
                }
            } catch let error {
                completion(nil, error)
                print(error)
            }
        }
    }
    
    //Update Profile.
    static func updateUserProfile(request: UserRequest, completion: @escaping (_ result: ResonseModel?, _ error: Error?) -> ()){
        
        print(request.toJSON())
        
        provider.request(.updateUserProfile(dic: request.toJSON())) { result in
            do {
                switch result {
                case .success(let response):
                    let json = try response.mapJSON()
                    print(String(describing: response.request))
                    print(String(describing: json))
                    let response = Mapper<ResonseModel>().map(JSONObject:json)
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                    print(error)
                }
            } catch let error {
                completion(nil, error)
                print(error)
            }
        }
    }
    //Create restaurant.
    static func createRestaurant(request: LicenseModel, completion: @escaping (_ result: LicenseResponse?, _ error: Error?) -> ()){
        
        print(request.toJSON())
        
        provider.request(.createRestaurant(dic: request.toJSON())) { result in
            do {
                switch result {
                case .success(let response):
                    let json = try response.mapJSON()
                    print(String(describing: response.request))
                    print(String(describing: json))
                    let response = Mapper<LicenseResponse>().map(JSONObject:json)
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                    print(error)
                }
            } catch let error {
                completion(nil, error)
                print(error)
            }
        }
    }
    
    //Create restaurant.
    static func updateRestaurant(request: RestaurantRequest, completion: @escaping (_ result: ResonseModel?, _ error: Error?) -> ()){
        
        print(request.toJSON())
        
        provider.request(.updateRestaurant(model: request)) { result in
            do {
                switch result {
                case .success(let response):
                    let json = try response.mapJSON()
                    print(String(describing: response.request))
                    print(String(describing: json))
                    let response = Mapper<ResonseModel>().map(JSONObject:json)
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                    print(error)
                }
            } catch let error {
                completion(nil, error)
                print(error)
            }
        }
    }
    
   
    static func getCategoty(completion: @escaping (_ result: [CategoryModel]?, _ error: Error?) -> ()){
    
         provider.request(.getCagegory) { result in
            do {
                switch result {
                case .success(let response):
                    let json = try response.mapJSON()
                    print(String(describing: response.request))
                    print(String(describing: json))
            
                    let response = Mapper<CategoryModelData>().map(JSONObject: json)
                    
                    var categoryArray: [CategoryModel] = []
                    for (_, value) in response?.data ?? [:] {
                        categoryArray.append(value)
                    }
                    
                    completion(categoryArray, nil)
                case .failure(let error):
                    completion(nil, error)
                    print(error)
                }
            } catch let error {
                completion(nil, error)
                print(error)
            }
        }
    }
	
    static func uploadPhoto(dataImage: Data, completion: @escaping (_ result: PhotoModel?, _ error: Error?) -> ()){
        
        let imageName = "\(Date().timeIntervalSinceNow)" // named base on current time
        
        let mutilPartForm = MultipartFormData(provider: .data(dataImage), name: "file", fileName: imageName, mimeType: "image/jpeg")
        
        provider.request(.uploadPhoto(dic: mutilPartForm)) { result in
            do {
                switch result {
                case .success(let response):
                    let json = try response.mapJSON()
                    print(String(describing: response.request))
                    print(String(describing: json))
                    let response = Mapper<PhotoModel>().map(JSONObject:json)
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                    print(error)
                }
            } catch let error {
                completion(nil, error)
                print(error)
            }
        }
    }
    
    static func getFoodWithRestaurantId(id: String, completion: @escaping (_ result: FoodResponse?, _ error: Error?) -> ()){
        
        
        provider.request(.getFoodWithRestaurantId(id: id)) { result in
            do {
                switch result {
                case .success(let response):
                    let json = try response.mapJSON()
                    print(String(describing: response.request))
                    print(String(describing: json))
                    let response = Mapper<FoodResponse>().map(JSONObject:json)
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                    print(error)
                }
            } catch let error {
                completion(nil, error)
                print(error)
            }
        }
    }
    //Add new by Tran Toan 29/07/2019.
    static func addCommentRestaurant(request: CommentRequest,  completion: @escaping (_ result: CommentRestaurantModel?, _ error: Error?) -> ()){
         print(request.toJSON())
        provider.request(.addComment(dic: request.toJSON())) { result in
            do {
                switch result {
                case .success(let response):
                    let json = try response.mapJSON()
                    print(String(describing: response.request))
                    print(String(describing: json))
                    let response = Mapper<CommentRestaurantModel>().map(JSONObject:json)
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error)
                    print(error)
                }
            } catch let error {
                completion(nil, error)
                print(error)
            }
        }
    }
    
    static func getRestaurantWithProfile(completion: @escaping (_ result: UserProfile?) -> ()){
        provider.request(.getRestaurantWithProfile) { result in
            do {
                switch result {
                case .success(let response):
                    let json = try response.mapJSON()
                    print(String(describing: response.request))
                    print(String(describing: json))
                    let response = Mapper<UserProfile>().map(JSONObject:json)
                    completion(response)
                case .failure(let error):
                    completion(nil)
                    print(error)
                }
            } catch let error {
                completion(nil)
                print(error)
            }
        }
    }
    
    static func addFood(foodRequest: FoodRequest, completion: @escaping (_ result: ResonseModel?) -> ()){
        provider.request(.addFood(dic: foodRequest.toJSON())) { result in
            do {
                switch result {
                case .success(let response):
                    let json = try response.mapJSON()
                    print(String(describing: response.request))
                    print(String(describing: json))
                    let response = Mapper<ResonseModel>().map(JSONObject:json)
                    completion(response)
                case .failure(let error):
                    completion(nil)
                    print(error)
                }
            } catch let error {
                completion(nil)
                print(error)
            }
        }
    }
}


class ResonseModel: Mappable {
    
    var status_code: Int = -1
    var message: String = ""
    var isSuccess: Bool = false
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.status_code <- map["status_code"]
        self.message <- map["message"]
        if status_code == 0 {
            isSuccess = true
        } else {
            isSuccess = false
        }
    }
}
