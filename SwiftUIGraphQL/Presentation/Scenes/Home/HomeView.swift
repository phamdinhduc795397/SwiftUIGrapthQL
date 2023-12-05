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
            listView(films)
        case .error(let message):
            errorView(message)
        case .loading:
            ProgressView()
        }
    }
    
    @ViewBuilder
    func listView(_ films: [FilmModel]) -> some View {
        List {
            ForEach(films, id: \.title) { item in
                NavigationLink(destination: DetailView(film: item), label: {
                    FilmItem(data: item)
                })
            }
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    func errorView(_ message: String) -> some View {
        VStack {
            Text(message)
                .padding()
            Button {
                viewModel.retry()
            } label: {
                Text("Retry")
                    .foregroundColor(.white)
                    .bold()
            }
            .padding()
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
    }
}
