//
//  LibraryAlbumsResponse.swift
//  MySpotify
//
//  Created by Alexander Germek on 08.07.2021.
//

import Foundation


struct LibraryAlbumsResponse: Codable {
    
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    
    let added_at: String
    let album: Album
}
