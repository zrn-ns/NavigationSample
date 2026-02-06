//
//  HomeEvent.swift
//  NavigationSample
//

import Foundation

/// Home Feature から App 層へ通知するイベント
///
/// 原則9: Viewは遷移の決定権を持たない
/// 手段6: Feature間遷移はEventとして上位に委譲する
enum HomeEvent {
    /// 設定画面を開きたい
    case openSettings
}
