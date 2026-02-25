//
//  LikeStore.swift
//  NavigationSample
//

import Foundation

/// いいね済み状態を管理するストア（アプリ全体で共有）
@MainActor
@Observable
final class LikeStore {
    static let shared = LikeStore()

    /// いいね済みユーザの ID セット
    private var likedUserIds: Set<User.ID> = []

    private init() {}

    /// 指定ユーザがいいね済みかどうか
    func isLiked(userId: User.ID) -> Bool {
        likedUserIds.contains(userId)
    }

    /// 指定ユーザをいいね済みにする
    func markAsLiked(userId: User.ID) {
        likedUserIds.insert(userId)
    }
}
