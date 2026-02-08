//
//  SettingsRouter.swift
//  NavigationSample
//

import SwiftUI

/// Settings Feature のルーティングを管理
///
/// Feature 内に push 遷移を持たず、Event 委譲のみの最小 Router。
/// RootView で生成し、子 View にバケツリレーで渡す。
@MainActor
@Observable
final class SettingsRouter {
    /// App 層へのイベント通知
    var onEvent: ((SettingsEvent) -> Void)?

    /// App 層イベントを発火
    func sendEvent(_ event: SettingsEvent) {
        onEvent?(event)
    }
}
