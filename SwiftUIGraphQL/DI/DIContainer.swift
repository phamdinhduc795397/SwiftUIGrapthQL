//
//  DIContainer.swift
//  SwiftUIGraphQL
//
//  Created by Duc Pham on 05/12/2023.
//

import Foundation
import Factory

extension Container {
    var apiService: Factory<APIService> {
        Factory(self) { APIManager() }
    }
}
