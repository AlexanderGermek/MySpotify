//
//  SearchResult.swift
//  MySpotify
//
//  Created by iMac on 03.07.2021.
//

import Foundation


enum SearchResult {
    
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
