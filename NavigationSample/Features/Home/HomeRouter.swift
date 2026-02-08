//
//  HomeRouter.swift
//  NavigationSample
//

import SwiftUI

/// Home Feature のルーティングを管理
///
/// RootView で生成し、子 View にバケツリレーで渡す。
/// Environment ではなくバケツリレーにすることで、注入忘れをコンパイル時に検出できる。
@MainActor
@Observable
final class HomeRouter {
    /// Feature 内の push 遷移状態
    var path: [HomeRoute] = []

    /// Feature 内の modal 状態
    var modal: HomeModal?

    /// App 層へのイベント通知
    var onEvent: ((HomeEvent) -> Void)?

    /// push 遷移
    func navigate(to route: HomeRoute) {
        path.append(route)
    }

    /// 編集モーダルを表示
    func showEdit(itemId: Item.ID) {
        modal = .edit(itemId)
    }

    /// UIKit 詳細画面をモーダルで表示
    func showLegacyItemDetail(itemId: Item.ID) {
        modal = .legacyItemDetail(itemId)
    }

    /// モーダルを閉じる
    func dismissModal() {
        modal = nil
    }

    /// App 層イベントを発火
    func sendEvent(_ event: HomeEvent) {
        onEvent?(event)
    }
}
