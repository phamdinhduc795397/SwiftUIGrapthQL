//
//  ActivityTracker.swift
//  SwiftUIGraphQL
//
//  Created by Duc Pham on 05/12/2023.
//

import Foundation
import Combine

public typealias ActivityTracker = CurrentValueSubject<Bool, Never>

extension Publisher {
    public func trackActivity(_ activityTracker: ActivityTracker) -> AnyPublisher<Self.Output, Self.Failure> {
        return handleEvents(receiveSubscription: { _ in
            activityTracker.send(true)
        }, receiveCompletion: { _ in
            activityTracker.send(false)
        }, receiveCancel: {
            activityTracker.send(false)
        })
        .eraseToAnyPublisher()
    }
}
