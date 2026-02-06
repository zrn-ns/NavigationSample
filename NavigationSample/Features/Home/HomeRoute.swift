//
//  HomeRoute.swift
//  NavigationSample
//

import Foundation

/// Home Feature 内の push 遷移用 Route
///
/// 原則1: NavigationStack（push）は同一Feature内に限定する
/// 手段1: Feature単位でRouteを定義する
enum HomeRoute: Hashable {
    case itemDetail(Item.ID)
}
