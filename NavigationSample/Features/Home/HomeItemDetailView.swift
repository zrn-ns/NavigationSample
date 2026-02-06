//
//  HomeItemDetailView.swift
//  NavigationSample
//

import SwiftUI

/// アイテム詳細画面
///
/// dismiss は「現在の文脈を終了したい」という意図の表明。
/// NavigationStack 内では pop、Modal 内では dismiss として動作する。
struct HomeItemDetailView: View {
    let item: Item
    /// Feature 内ルーティング（バケツリレー）
    let router: HomeRouter
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(item.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(item.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(spacing: 12) {
                Button("関連アイテムを見る") {
                    router.navigate(to: .itemRelated(item.id))
                }
                .buttonStyle(.bordered)

                Button("編集") {
                    router.showEdit(itemId: item.id)
                }
                .buttonStyle(.borderedProminent)

                Button("戻る") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .navigationTitle("詳細")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HomeItemDetailView(
            item: Item.samples[0],
            router: HomeRouter()
        )
    }
}
