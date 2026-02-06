//
//  NavigationSampleApp.swift
//  NavigationSample
//
//  Created by nagao.yuki on 2026/02/05.
//

import SwiftUI

@main
struct NavigationSampleApp: App {
    /// アプリ全体の状態
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            MainTabView(appState: appState)
        }
    }
}
