//
//  ErrorTracker.swift
//  SwiftUIGraphQL
//
//  Created by Duc Pham on 05/12/2023.
//

import Foundation
import Combine

public typealias ErrorTracker = PassthroughSubject<Error, Never>

extension Publisher {
    public func trackError(_ errorTracker: ErrorTracker) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                errorTracker.send(error)
            }
        })
        .eraseToAnyPublisher()
    }
}
