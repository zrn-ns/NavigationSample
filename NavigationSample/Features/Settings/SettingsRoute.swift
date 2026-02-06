//
//  SettingsRoute.swift
//  NavigationSample
//

import Foundation

/// Settings Feature 内の push 遷移用 Route
///
/// 原則1: NavigationStack（push）は同一Feature内に限定する
enum SettingsRoute: Hashable {
    case detail(String)
}
