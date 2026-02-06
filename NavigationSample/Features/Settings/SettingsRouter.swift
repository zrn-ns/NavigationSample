//
//  SettingsRouter.swift
//  NavigationSample
//

import SwiftUI

/// Settings Feature のルーティングを管理
///
/// RootView で生成し、子 View にバケツリレーで渡す。
/// Environment ではなくバケツリレーにすることで、注入忘れをコンパイル時に検出できる。
@MainActor
@Observable
final class SettingsRouter {
    /// Feature 内の push 遷移状態
    var path: [SettingsRoute] = []

    /// App 層へのイベント通知
    var onEvent: ((SettingsEvent) -> Void)?

    /// push 遷移
    func navigate(to route: SettingsRoute) {
        path.append(route)
    }

    /// App 層イベントを発火
    func sendEvent(_ event: SettingsEvent) {
        onEvent?(event)
    }
}
