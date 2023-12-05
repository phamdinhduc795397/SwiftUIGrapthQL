//
//  HomeView.swift
//  SwiftUIGraphQL
//
//  Created by Duc Pham on 04/12/2023.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.allFilms, id: \.title) { item in
                    NavigationLink(destination: DetailView(film: item), label: {
                        FilmItem(data: item)
                    })
                }
            }
            .listStyle(.plain)
        }
        .onAppear(perform: viewModel.fetchData)
        .searchable(text: $viewModel.searchText)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
    }
}
