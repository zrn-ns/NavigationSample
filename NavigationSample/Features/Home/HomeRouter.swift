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

    /// push 遷移
    func navigate(to route: HomeRoute) {
        path.append(route)
    }

    /// 編集モーダルを表示
    func showEdit(itemId: Item.ID) {
        modal = .edit(itemId)
    }

    /// モーダルを閉じる
    func dismissModal() {
        modal = nil
    }
}
