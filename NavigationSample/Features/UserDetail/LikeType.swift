//
//  LikeType.swift
//  NavigationSample
//

import Foundation

/// いいねの種別
enum LikeType {
    /// 通常のいいね（1pt）
    case normal

    /// スペシャルいいね（3pt）
    case special

    /// 消費ポイント
    var cost: Int {
        switch self {
        case .normal: 1
        case .special: 3
        }
    }

    /// 表示名
    var displayName: String {
        switch self {
        case .normal: "いいね"
        case .special: "スペシャルいいね"
        }
    }
}
