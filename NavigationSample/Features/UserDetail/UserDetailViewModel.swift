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

    /// いいね済みかどうか（実際のアプリでは API から取得した初期値を使用）
    var isLiked: Bool

    init(user: User, displayMode: DisplayMode = .standard, isLiked: Bool = false) {
        self.user = user
        self.displayMode = displayMode
        self.isLiked = isLiked
    }

    /// いいねを送る（実際のアプリでは API リクエストを行う）
    func sendLike(_ type: LikeType) {
        isLiked = true
    }

    /// ユーザをブロックする（実際のアプリでは API リクエストを行う）
    func blockUser() {
        // API リクエスト等のビジネスロジック
        // イベント通知は呼び出し元が Router 経由で行う
    }
}
