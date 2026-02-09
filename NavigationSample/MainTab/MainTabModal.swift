//
//  MainTabModal.swift
//  NavigationSample
//

import Foundation

/// MainTab スコープで管理する Modal 定義
///
/// 原則8: Modal enum は「文脈のスコープ」で定義する
/// - MainTab 文脈 → MainTabModal
enum MainTabModal: Identifiable, Hashable {
    case profilePreview

    var id: Self { self }
}
