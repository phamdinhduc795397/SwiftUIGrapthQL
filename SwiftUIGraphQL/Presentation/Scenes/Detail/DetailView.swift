//
//  DetailView.swift
//  SwiftUIGraphQL
//
//  Created by Duc Pham on 04/12/2023.
//

import SwiftUI

struct DetailView: View {
    let film: FilmModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(film.title)
                .bold()
            if let episodeID = film.episodeID {
                Text("\(episodeID)")
                    .bold()
            }
            Text(film.openingCrawl)
            characterList(film.characters)
            Spacer()
        }
    }
    
    @ViewBuilder
    func characterList(_ characters: [CharacterModel]) -> some View {
        VStack(alignment: .leading) {
            Text("Characters: ").bold()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(characters, id: \.name) { item in
                        Text(item.name)
                    }
                }
            }
        }
    }
}
