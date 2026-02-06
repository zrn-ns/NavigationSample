//
//  LoginRoute.swift
//  NavigationSample
//

import Foundation

/// Login Feature 内の push 遷移用 Route
///
/// 原則1: NavigationStack（push）は同一Feature内に限定する
enum LoginRoute: Hashable {
    case complete
}
