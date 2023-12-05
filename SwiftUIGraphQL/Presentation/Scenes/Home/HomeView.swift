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
            contentView()
        }
        .navigationTitle("Star War")
        .onAppear(perform: viewModel.fetchData)
        .searchable(text: $viewModel.searchText)
    }
    
    @ViewBuilder
    func contentView() -> some View {
        switch viewModel.state {
        case .success(let films):
            List {
                ForEach(films, id: \.title) { item in
                    NavigationLink(destination: DetailView(film: item), label: {
                        FilmItem(data: item)
                    })
                }
            }
            .listStyle(.plain)
        case .error:
            Text("Something went wrong!")
        case .loading:
            ProgressView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
    }
}
