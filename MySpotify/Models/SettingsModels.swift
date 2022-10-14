//
//  SettingsModels.swift
//  MySpotify
//
//  Created by Alexander Germek on 16.05.2021.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
