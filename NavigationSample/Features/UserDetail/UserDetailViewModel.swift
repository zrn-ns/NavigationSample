//
//  UserDetailViewModel.swift
//  NavigationSample
//

import SwiftUI

/// UserDetail Feature のビジネスロジックを管理
@MainActor
@Observable
final class UserDetailViewModel {
    /// 表示モード
    enum DisplayMode {
        /// 通常表示（他ユーザの詳細）
        case standard
        /// 自分のプロフィール表示
        case me
    }

    /// 表示対象のユーザ
    let user: User

    /// 表示モード
    let displayMode: DisplayMode

    /// いいね済みかどうか（LikeStore 経由で取得）
    var isLiked: Bool {
        LikeStore.shared.isLiked(userId: user.id)
    }

    init(user: User, displayMode: DisplayMode = .standard) {
        self.user = user
        self.displayMode = displayMode
    }

    /// いいねを送る（実際のアプリでは API リクエストを行う）
    func sendLike(_ type: LikeType) {
        LikeStore.shared.markAsLiked(userId: user.id)
    }

    /// ユーザをブロックする（実際のアプリでは API リクエストを行う）
    func blockUser() {
        // API リクエスト等のビジネスロジック
        // イベント通知は呼び出し元が onEvent クロージャ経由で行う
    }
}
