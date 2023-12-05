//
//  CharacterModel.swift
//  SwiftUIGraphQL
//
//  Created by Duc Pham on 04/12/2023.
//

import Foundation
import StarWarsAPI

struct CharacterModel {
    let name: String
    
    init(data: AllFilmsQuery.Data.AllFilms.Film.CharacterConnection.Character) {
        self.name = data.name ?? ""
    }
}
