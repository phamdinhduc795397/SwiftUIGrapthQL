//
//  FilmModel.swift
//  SwiftUIGraphQL
//
//  Created by Duc Pham on 04/12/2023.
//

import Foundation
import StarWarsAPI

struct FilmModel {
    let title: String
    let releaseDate: String
    let openingCrawl: String
    let episodeID: Int?
    let characters: [CharacterModel]
    
    init(data: AllFilmsQuery.Data.AllFilms.Film) {
        self.title = data.title ?? ""
        self.releaseDate = data.releaseDate ?? ""
        self.openingCrawl = data.openingCrawl ?? ""
        self.episodeID = data.episodeID ?? 0
        self.characters = data.characterConnection?
            .characters?
            .compactMap { $0 }
            .map {
                CharacterModel(data: $0)
            } ?? []
    }
}
