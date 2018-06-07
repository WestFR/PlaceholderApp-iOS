//
//  UserModel.swift
//  TPFinal-iOS
//
//  Created by Steven F. on 07/06/2018.
//  Copyright © 2018 Steven F. All rights reserved.
//

import UIKit

struct UserModel: Codable {
    let id : Int?
    let name : String?
    let username : String?
    let email : String?
    let address : AdressModel?
    let phone : String?
    let website : String?
    let company : CompanyModel?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case username = "username"
        case email = "email"
        case address
        case phone = "phone"
        case website = "website"
        case company
    }
}

struct AdressModel: Codable {
    let street : String?
    let suite : String?
    let city : String?
    let zipcode : String?
    let geo : PositionModel?
    
    enum CodingKeys: String, CodingKey {
        case street = "street"
        case suite = "suite"
        case city = "city"
        case zipcode = "zipcode"
        case geo
    }
}

struct CompanyModel: Codable {
    let name : String?
    let catchPhrase : String?
    let bs : String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case catchPhrase = "catchPhrase"
        case bs = "bs"
    }
}

struct PositionModel: Codable {
    let lat : String?
    let lng : String?
    
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }
}
