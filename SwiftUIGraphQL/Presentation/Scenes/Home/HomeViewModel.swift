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

enum ViewState<T> {
    case success(T), error, loading
}

class HomeViewModel: ObservableObject {
    let apiService: APIService = APIManager()
    private var cancellables = Set<AnyCancellable>()
    private let fetchDataStream = PassthroughRelay<Void>()
    
    
    private let errorTracker = ErrorTracker()
    private let activityTracker = ActivityTracker(false)
    
    @Published var searchText = ""
    @Published var isLoading = ""
    
    @Published var state: ViewState<[FilmModel]> = .loading

    init() {
        initData()
    }
    
    private func initData() {
        let fetchingFilms = fetchDataStream
            .prefix(1)
            .withUnretained(self)
            .flatMap { base, _ in
                base.fetchAllFilms()
            }
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
            .map { ViewState.success($0) }
            .assign(to: \.state, on: self, ownership: .weak)
            .store(in: &cancellables)
        
        errorTracker
            .map { _ in ViewState.error }
            .assign(to: \.state, on: self, ownership: .weak)
            .store(in: &cancellables)
    }
    
    private func fetchAllFilms() -> AnyPublisher<[FilmModel], Never> {
        apiService.fetchAllFilms()
            .trackError(errorTracker)
            .trackActivity(activityTracker)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}

extension HomeViewModel {
    func fetchData() {
        fetchDataStream.accept()
    }
}
