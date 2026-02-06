//
//  HomeItemEditView.swift
//  NavigationSample
//

import SwiftUI

/// アイテム編集画面（Feature 内 Modal）
///
/// 原則12: Modal内の処理結果は「閉じる命令」ではなく「イベント」として返す
struct HomeItemEditView: View {
    let item: Item
    let onSave: (Item) -> Void
    let onCancel: () -> Void

    @State private var title: String
    @State private var description: String

    init(item: Item, onSave: @escaping (Item) -> Void, onCancel: @escaping () -> Void) {
        self.item = item
        self.onSave = onSave
        self.onCancel = onCancel
        self._title = State(initialValue: item.title)
        self._description = State(initialValue: item.description)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("タイトル", text: $title)
                    TextField("説明", text: $description)
                } header: {
                    Text("アイテム情報")
                }
            }
            .navigationTitle("編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        onCancel()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        let editedItem = Item(
                            id: item.id,
                            title: title,
                            description: description
                        )
                        onSave(editedItem)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeItemEditView(
        item: Item.samples[0],
        onSave: { _ in },
        onCancel: {}
    )
}
