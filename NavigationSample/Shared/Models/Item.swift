//
//  Item.swift
//  NavigationSample
//

import Foundation

/// サンプルデータモデル
struct Item: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String

    init(id: UUID = UUID(), title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}

// MARK: - サンプルデータ

extension Item {
    static let samples: [Item] = [
        Item(title: "アイテム 1", description: "これは最初のアイテムです。"),
        Item(title: "アイテム 2", description: "これは2番目のアイテムです。"),
        Item(title: "アイテム 3", description: "これは3番目のアイテムです。"),
        Item(title: "アイテム 4", description: "これは4番目のアイテムです。"),
        Item(title: "アイテム 5", description: "これは5番目のアイテムです。"),
    ]
}
