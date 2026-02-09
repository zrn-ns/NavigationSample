//
//  UserDetailModal.swift
//  NavigationSample
//

import Foundation

/// UserDetail Feature 内で表示する modal を表す
///
/// パターン A: SwiftUI から UIKit 画面を modal で表示
enum UserDetailModal: Identifiable {
    /// いいね送信画面（UIKit）
    case likeSend

    var id: Self { self }
}
