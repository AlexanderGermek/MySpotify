//
//  BrowseSectionType.swift
//  MySpotify
//
//  Created by Alexander Germek on 09.07.2021.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModels: [NewReleasesCellViewModel]) //1 section
    case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel]) //2
    case recommendedTracks(viewModels: [RecommendedTrackCellViewModel]) // 3
    
    var title: String {
        switch self {
        case .newReleases:
            return "New released Albums"
        case .featuredPlaylists:
            return "Featured Playlists"
        case .recommendedTracks:
            return "Recommended"
        }
    }
}
