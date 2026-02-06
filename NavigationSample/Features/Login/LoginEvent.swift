//
//  LoginEvent.swift
//  NavigationSample
//

import Foundation

/// Login Feature から App 層へ通知するイベント
///
/// 原則12: Modal内の処理結果は「閉じる命令」ではなく「イベント」として返す
enum LoginEvent {
    /// ログイン完了
    case completed
    /// キャンセル
    case cancelled
}
