//
//  StarWarModel.swift
//  SwiftUIGraphQL
//
//  Created by Duc Pham on 04/12/2023.
//

import Foundation

struct StarWarModel {
    let title: String
    let releaseDate: String
    let openingCrawl: String
    let episodeID: Int?
    let characters: [CharacterModel]?
}
