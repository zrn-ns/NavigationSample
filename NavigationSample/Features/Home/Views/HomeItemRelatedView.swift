//
//  HomeItemRelatedView.swift
//  NavigationSample
//

import SwiftUI

/// 関連アイテム画面（2段階目の push 遷移）
///
/// router のみをバケツリレーすることで、引数の増加を抑制
struct HomeItemRelatedView: View {
    let item: Item
    let relatedItems: [Item]
    /// Feature 内ルーティング（バケツリレー）
    let router: HomeRouter
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
                        router.navigate(to: .itemDetail(relatedItem.id))
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
                    router.showEdit(itemId: item.id)
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
            router: HomeRouter()
        )
    }
}
