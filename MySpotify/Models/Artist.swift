//
//  Artist.swift
//  MySpotify
//
//  Created by Alexander Germek on 15.05.2021.
//

import Foundation


struct Artist: Codable {
    
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
}
