//
//  HomeModal.swift
//  NavigationSample
//

import Foundation

/// Home Feature 内の Modal 定義
///
/// 原則8: ModalRoute は「文脈のスコープ」で定義する
/// - Feature 文脈 → FeatureModal
enum HomeModal: Identifiable, Hashable {
    case edit(Item.ID)

    var id: Self { self }
}
