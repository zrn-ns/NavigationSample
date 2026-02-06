//
//  AppRouter.swift
//  NavigationSample
//

import SwiftUI

/// アプリ全体のルーティングを管理
///
/// 原則3: Push用の状態とModal用の状態は分離する
/// - Tab選択状態
/// - App全体のModal状態
@MainActor
@Observable
final class AppRouter {
    /// 選択中のタブ
    var selectedTab: Tab = .home

    /// App全体で表示するModal
    var modal: AppModal?

    /// タブ定義
    enum Tab: Hashable {
        case home
        case settings
    }
}

// MARK: - Event Handling

extension AppRouter {
    /// Home Feature からのイベントを処理
    func handle(_ event: HomeEvent) {
        switch event {
        case .requireLogin:
            modal = .login
        case .openSettings:
            selectedTab = .settings
        }
    }

    /// Settings Feature からのイベントを処理
    func handle(_ event: SettingsEvent) {
        switch event {
        case .openHome:
            selectedTab = .home
        }
    }

    /// Login Feature からのイベントを処理
    func handle(_ event: LoginEvent) {
        switch event {
        case .completed:
            modal = nil
        case .cancelled:
            modal = nil
        }
    }
}
