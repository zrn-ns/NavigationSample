//
//  LoginRouter.swift
//  NavigationSample
//

import SwiftUI

/// Login Feature のルーティングを管理
///
/// RootView で生成し、子 View にバケツリレーで渡す。
/// Environment ではなくバケツリレーにすることで、注入忘れをコンパイル時に検出できる。
@MainActor
@Observable
final class LoginRouter {
    /// Feature 内の push 遷移状態
    var path: [LoginRoute] = []

    /// App 層へのイベント通知
    var onEvent: ((LoginEvent) -> Void)?

    /// push 遷移
    func navigate(to route: LoginRoute) {
        path.append(route)
    }

    /// 前の画面に戻る
    func goBack() {
        path.removeLast()
    }

    /// App 層イベントを発火
    func sendEvent(_ event: LoginEvent) {
        onEvent?(event)
    }
}
