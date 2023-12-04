//
//  ListItem.swift
//  SwiftUIGraphQL
//
//  Created by Duc Pham on 04/12/2023.
//

import SwiftUI

struct StarWarItem: View {
    let data: StarWarModel
    var body: some View {
        VStack(alignment: .leading) {
            Text(data.title).bold()
            Text(data.releaseDate)
        }
    }
}
