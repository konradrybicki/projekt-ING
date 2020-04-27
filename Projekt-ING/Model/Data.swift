//
//  Data.swift
//  Projekt-ING
//
//  Created by Konrad Rybicki on 26/04/2020.
//  Copyright © 2020 Konrad Rybicki. All rights reserved.
//

import Foundation

//struktury dla JSON'a

struct Post: Decodable {
    let userId:Int
    let id:Int
    let title:String
    let body:String
}

struct Comment: Decodable {
    let postId:Int
    let id:Int
    let name:String
    let email:String
    let body:String
}

struct Album: Decodable {
    let userId:Int
    let id:Int
    let title:String
}

struct Photo: Decodable {
    let albumId:Int
    let id:Int
    let title:String
    let url:String
    let thumbnailUrl:String
}

//ta różni się nieco od pozostałych

struct Geo: Decodable {
    let lat:String
    let lng:String
}

struct Adress: Decodable {
    let street:String
    let suite:String
    let city:String
    let zipcode:String
    let geo:Geo
}

struct Company: Decodable {
    let name:String
    let catchPhrase:String
    let bs:String
}

struct User: Decodable {
    let id:Int
    let name:String
    let username:String
    let email:String
    let address:Adress
    let phone:String
    let website:String
    let company:Company
}
