//
//  UserDetailRoute.swift
//  NavigationSample
//

import Foundation

/// UserDetail Feature 内の push 遷移先を表す
///
/// 詳細 → 写真一覧 → 写真拡大 のような Feature 内遷移に使用
enum UserDetailRoute: Hashable {
    /// 写真一覧
    case photos

    /// 写真詳細
    case photoDetail(photoId: User.Photo.ID)
}
