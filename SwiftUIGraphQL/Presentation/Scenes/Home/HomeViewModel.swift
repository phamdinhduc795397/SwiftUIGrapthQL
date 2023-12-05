//
//  HomeViewModel.swift
//  SwiftUIGraphQL
//
//  Created by Duc Pham on 04/12/2023.
//

import Foundation
import Combine
import CombineExt
import StarWarsAPI

class HomeViewModel: ObservableObject {
    let apiService: APIService = APIManager()
    private var cancellable = Set<AnyCancellable>()
    private let fetchDataStream = PassthroughRelay<Void>()
    
    @Published var allFilms: [FilmModel] = []
    @Published var searchText = ""
    
    init() {
        initData()
    }
    
    private func initData() {
        let fetchingFilms = fetchDataStream
            .flatMap { [unowned self] in
                apiService.fetchAllFilms()
            }
            .replaceError(with: [])
            .share()
        
        
        let searchFilms = $searchText
            .withLatestFrom(fetchingFilms) { text, films in
                if text.isEmpty {
                    return films
                }
                return films.filter { film in
                    film.title.contains(text) == true
                }
            }
        
        let allFilms = Publishers.Merge(fetchingFilms, searchFilms)
        allFilms
            .assign(to: \.allFilms, on: self, ownership: .weak)
            .store(in: &cancellable)
    }
}

extension HomeViewModel {
    func fetchData() {
        fetchDataStream.accept()
    }
}
