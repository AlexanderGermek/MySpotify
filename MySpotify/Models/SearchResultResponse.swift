//
//  SearchResultResponse.swift
//  MySpotify
//
//  Created by Alexander Germek on 03.07.2021.
//

import Foundation


struct SearchResultResponse: Codable {
    
    let albums: SearchAlbumResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTracksResponse
}


struct SearchAlbumResponse: Codable {
    let items: [Album]
}


struct SearchArtistsResponse: Codable {
    let items: [Artist]
}

struct SearchPlaylistsResponse: Codable {
    let items: [Playlist]
}

struct SearchTracksResponse: Codable {
    let items: [AudioTrack]
}

