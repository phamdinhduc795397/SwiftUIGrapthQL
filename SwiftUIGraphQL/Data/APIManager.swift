//
//  APIManager.swift
//  SwiftUIGraphQL
//
//  Created by Duc Pham on 04/12/2023.
//

import Combine
import Apollo
import StarWarsAPI
import Foundation

enum APIError: Error {
    case failed([GraphQLError])
}

protocol APIService {
    func fetchAllFilms() -> AnyPublisher<AllFilmsQuery.Data, Error>
}

class APIManager {
    static let shared = APIManager()
    private lazy var client: ApolloClient = {
        let apolloClient = ApolloClient(url: URL(string: "https://swapi-graphql.netlify.app/.netlify/functions/index")!)
        return apolloClient
    }()
    
    func fetch<Query: GraphQLQuery>(query: Query) -> AnyPublisher<Query.Data, Error> {
        return Future { emiter in
            self.client.fetch(query: query) { result in
                switch result {
                case let .success(graphResult):
                    if let data = graphResult.data {
                        emiter(.success(data))
                        return
                    }
                    if let errors = graphResult.errors {
                        emiter(.failure(APIError.failed(errors)))
                        return
                    }
                case let .failure(error):
                    emiter(.failure(error))
                }
            }
            
        }
        .eraseToAnyPublisher()
    }
}

extension APIManager: APIService {
    func fetchAllFilms() -> AnyPublisher<AllFilmsQuery.Data, Error> {
        fetch(query: AllFilmsQuery())
    }
}
