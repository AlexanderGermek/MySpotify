//
//  NewReleasesResponse.swift
//  MySpotify
//
//  Created by Alexander Germek on 17.05.2021.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}

struct Album: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let id: String
    var images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
}


