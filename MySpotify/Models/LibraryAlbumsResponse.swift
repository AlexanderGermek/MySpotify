//
//  LibraryAlbumsResponse.swift
//  MySpotify
//
//  Created by iMac on 08.07.2021.
//

import Foundation


struct LibraryAlbumsResponse: Codable {
    
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    
    let added_at: String
    let album: Album
}
