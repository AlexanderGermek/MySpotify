//
//  Playlist.swift
//  MySpotify
//
//  Created by Alexander Germek on 15.05.2021.
//

import Foundation


struct Playlist: Codable {
    
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}
