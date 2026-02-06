//
//  HomeView.swift
//  NavigationSample
//

import SwiftUI

/// ホーム画面（アイテム一覧）
///
/// 原則9: Viewは遷移の決定権を持たない
/// - onNavigate: Feature内遷移の意図を表明
/// - onEvent: Feature外遷移の意図を表明
struct HomeView: View {
    let items: [Item]
    let onNavigate: (HomeRoute) -> Void
    let onEvent: (HomeEvent) -> Void

    var body: some View {
        List {
            Section {
                ForEach(items) { item in
                    Button {
                        onNavigate(.itemDetail(item.id))
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
            onNavigate: { _ in },
            onEvent: { _ in }
        )
    }
}
