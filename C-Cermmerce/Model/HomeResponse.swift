//
//  HomeResponse.swift
//  C-Cermmerce
//
//  Created by 양시관 on 2/16/24.
//

import Foundation
import SwiftUI

struct HomeResponse : Decodable{
    let banners : [Banner]
    let horizontalProducts : [Product]
    let verticalProducts : [Product]
    let themes : [Banner]
}
struct Banner :Decodable{
    let id : Int
    let imageUrl: String
}

struct Product: Decodable{
    let id : Int
    let imageUrl : String
    let title: String
    let discount : String
    let originalPrice : Int
    let discountPrice : Int
}
