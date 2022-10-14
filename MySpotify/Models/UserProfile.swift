//
//  UserProfile.swift
//  MySpotify
//
//  Created by Alexander Germek on 15.05.2021.
//

import Foundation

struct UserProfile: Decodable {
    
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
   // let followers: [String: Codable?]
    let id: String
    let product: String
    let images: [APIImage]
}


