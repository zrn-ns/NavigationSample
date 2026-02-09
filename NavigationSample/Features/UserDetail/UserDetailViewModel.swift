//
//  UserDetailViewModel.swift
//  NavigationSample
//

import SwiftUI

/// UserDetail Feature のビジネスロジックを管理
@MainActor
@Observable
final class UserDetailViewModel {
    /// いいね済みかどうか（実際のアプリでは API から取得した初期値を使用）
    var isLiked: Bool

    init(isLiked: Bool = false) {
        self.isLiked = isLiked
    }

    /// いいねを送る（実際のアプリでは API リクエストを行う）
    func sendLike(_ type: LikeType) {
        isLiked = true
    }
}
