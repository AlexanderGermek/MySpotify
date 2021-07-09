//
//  FeaturedPlaylistsResponse.swift
//  MySpotify
//
//  Created by iMac on 17.05.2021.
//

import Foundation


struct FeaturedPlaylistResponse: Codable {
    let playlists: PlaylistResponse
    
}


struct CategoryPLaylistsResponse: Codable {
    let playlists: PlaylistResponse
    
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}

