//
//  PlaylistDetailsResponse.swift
//  MySpotify
//
//  Created by iMac on 06.06.2021.
//

import Foundation


struct PlaylistDetailsResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlaylistTracksResponse
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
    
}

struct PlaylistItem: Codable {
    let track: AudioTrack
}
