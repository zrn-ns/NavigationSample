//
//  HomeItemRelatedView.swift
//  NavigationSample
//

import SwiftUI

/// 関連アイテム画面（2段階目の push 遷移）
///
/// バケツリレーの例:
/// - onNavigate: さらに深い階層への遷移用（RootView から伝播）
/// - onShowEdit: 編集モーダル表示用（RootView から伝播）
struct HomeItemRelatedView: View {
    let item: Item
    let relatedItems: [Item]
    /// Feature 内の push 遷移（バケツリレー）
    let onNavigate: (HomeRoute) -> Void
    /// 編集モーダルを表示したいという意図の表明（バケツリレー）
    let onShowEdit: (Item.ID) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text("元のアイテム: \(item.title)")
                        .font(.headline)
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("参照元")
            }

            Section {
                ForEach(relatedItems) { relatedItem in
                    Button {
                        onNavigate(.itemDetail(relatedItem.id))
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(relatedItem.title)
                                    .font(.headline)
                                Text(relatedItem.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .foregroundStyle(.primary)
                }
            } header: {
                Text("関連アイテム")
            }

            Section {
                Button("このアイテムを編集") {
                    onShowEdit(item.id)
                }
                .foregroundStyle(.blue)
            } header: {
                Text("アクション")
            }
        }
        .navigationTitle("関連")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HomeItemRelatedView(
            item: Item.samples[0],
            relatedItems: Array(Item.samples.dropFirst()),
            onNavigate: { _ in },
            onShowEdit: { _ in }
        )
    }
}
