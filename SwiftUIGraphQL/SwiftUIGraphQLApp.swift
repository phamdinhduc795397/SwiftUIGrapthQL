//
//  SwiftUIGraphQLApp.swift
//  SwiftUIGraphQL
//
//  Created by Duc Pham on 04/12/2023.
//

import SwiftUI

@main
struct SwiftUIGraphQLApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: .init())
        }
    }
}
