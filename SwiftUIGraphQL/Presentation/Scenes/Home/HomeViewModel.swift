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
    
    @Published var allFilms: [StarWarModel] = []
    @Published var searchText = ""
    
    init() {
        initData()
    }
    
    private func initData() {
        let fetchingFilms = fetchDataStream
            .flatMap { [unowned self] in
                apiService.fetchAllFilms()
            }
            .compactMap { data in
                data.allFilms?.films?.compactMap { $0 }
            }
            .replaceError(with: [])
            .share()
        
        
        let searchFilms = $searchText
            .withLatestFrom(fetchingFilms) { text, films in
                if text.isEmpty {
                    return films
                }
                return films.filter { film in
                    film.title?.contains(text) == true
                }
            }
        
        
        let allFilms = Publishers.Merge(fetchingFilms, searchFilms)
            .map { [unowned self] films in
                mapData(films)
            }
        allFilms
            .assign(to: \.allFilms, on: self, ownership: .weak)
            .store(in: &cancellable)
    }
    
    
    private func mapData(_ films: [AllFilmsQuery.Data.AllFilms.Film]) -> [StarWarModel] {
        let items = films.map { film in
            let characters = film
                .characterConnection?
                .characters?
                .compactMap { $0 }.map { character in
                    CharacterModel(name: character?.name ?? "",
                                   birthday: character?.birthYear ?? "")
                }
            return  StarWarModel(title: film.title ?? "",
                                 releaseDate:  film.releaseDate ?? "",
                                 openingCrawl: film.openingCrawl ?? "",
                                 episodeID: film.episodeID,
                                 characters: characters)
        }
        return items
    }
}

extension HomeViewModel {
    func fetchData() {
        fetchDataStream.accept()
    }
}
