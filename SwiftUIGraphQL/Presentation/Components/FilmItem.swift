//
//  FilmItem.swift
//  SwiftUIGraphQL
//
//  Created by Duc Pham on 04/12/2023.
//

import SwiftUI

struct FilmItem: View {
    let data: FilmModel
    var body: some View {
        VStack(alignment: .leading) {
            Text(data.title).bold()
            Text(data.releaseDate)
        }
    }
}
