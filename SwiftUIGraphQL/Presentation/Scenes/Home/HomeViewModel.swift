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
    case success(T), error(String), loading
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
            .withUnretained(self)
            .map { base, error in
                base.handleError(error)
            }
            .map { message in ViewState.error(message) }
            .assign(to: \.state, on: self, ownership: .weak)
            .store(in: &cancellables)
        
        activityTracker
            .filter { $0 }
            .map {  _ in ViewState.loading }
            .assign(to: \.state, on: self, ownership: .weak)
            .store(in: &cancellables)
    }
    
    private func fetchAllFilms() -> AnyPublisher<[FilmModel], Never> {
        apiService.fetchAllFilms()
            .trackError(errorTracker)
            .trackActivity(activityTracker)
            .ignoreFailure()
            .eraseToAnyPublisher()
    }
    
    private func handleError(_ error: Error) -> String {
        guard let error = error as? APIError else {
            return error.localizedDescription
        }
        switch error {
        case .failed(let errors):
            return errors.first?.localizedDescription ?? ""
        }
    }

}

extension HomeViewModel {
    func fetchData() {
        fetchDataStream.accept()
    }
    
    func retry() {
        fetchDataStream.accept()
    }
}
