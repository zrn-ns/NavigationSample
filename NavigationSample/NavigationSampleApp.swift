//
//  NavigationSampleApp.swift
//  NavigationSample
//
//  Created by nagao.yuki on 2026/02/05.
//

import SwiftUI

@main
struct NavigationSampleApp: App {
    /// アプリ全体のルーター
    @State private var appRouter = AppRouter()

    var body: some Scene {
        WindowGroup {
            MainTabView(appRouter: appRouter)
        }
    }
}
