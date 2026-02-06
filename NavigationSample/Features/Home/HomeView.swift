//
//  HomeView.swift
//  NavigationSample
//

import SwiftUI

/// ホーム画面（アイテム一覧）
///
/// 原則9: Viewは遷移の決定権を持たない
/// - router: Feature内遷移用（バケツリレー）
/// - onEvent: Feature外遷移の意図を表明
struct HomeView: View {
    let items: [Item]
    let router: HomeRouter
    let onEvent: (HomeEvent) -> Void

    var body: some View {
        List {
            Section {
                ForEach(items) { item in
                    Button {
                        router.navigate(to: .itemDetail(item.id))
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .foregroundStyle(.primary)
                }
            } header: {
                Text("アイテム一覧")
            }

            Section {
                Button("ログインが必要な機能") {
                    onEvent(.requireLogin)
                }

                Button("設定を開く") {
                    onEvent(.openSettings)
                }
            } header: {
                Text("アクション")
            }
        }
        .navigationTitle("ホーム")
    }
}

#Preview {
    NavigationStack {
        HomeView(
            items: Item.samples,
            router: HomeRouter(),
            onEvent: { _ in }
        )
    }
}
