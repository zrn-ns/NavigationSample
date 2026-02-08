//
//  UserDetailModal.swift
//  NavigationSample
//

import Foundation

/// UserDetail Feature 内で表示する modal を表す
///
/// パターン A: SwiftUI から UIKit 画面を modal で表示
enum UserDetailModal: Identifiable {
    /// レガシープロフィール画面（UIKit）
    case legacyProfile

    var id: String {
        switch self {
        case .legacyProfile:
            return "legacyProfile"
        }
    }
}
