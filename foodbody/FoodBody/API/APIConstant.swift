//
//  APIConstant.swift
//  FoodBody
//
//  Created by Phuoc on 6/18/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation

struct APIConstant {
    static let BASE_URL = "https://foodbodi.appspot.com"
    static let login = "/api/login"
    static let signup = "/api/register"
    static let googleSignIn = "/api/googleSignIn"
    static let facebookSignIn = "/api/facebookSignIn"
    static let getProfile = "/api/profile"
    static let updateUserProfile = "/api/profile"
    //API Restaurant.
    static let createRestaurant = "/api/restaurant"
    static let getCategory = "/api/metadata/restaurant_category"
	static let uploadPhoto = "/api/upload/photo"
    static let getFoodWithRestaurantId = "/api/restaurant"
    static let updateRestaurant = "/api/restaurant"
    static let getRestaurantWithProfile = "/api/profile"
    static let getMyRestaurant = "/api/restaurant/mine"
    //API Food
    static let deleteFood = "/api/food"
    //API comment.
    static let addComment = "/api/comment"
    static let addFood = "api/food"
    //API Reservation.
    static let addReservation = "/api/reservation"
    static let getListReservation = "/api/reservation/mine"
    static let getOneReservation = "/api/reservation"
    static let updateReservation = "/api/reservation"
    //API Profile
    static let updateDailyLog = "/api/dailylog"
    //API search.
    static let searchFodiMap = "/api/search?q="
}



