//
//  HomeView.swift
//  NavigationSample
//

import SwiftUI

/// ホーム画面（アイテム一覧）
///
/// 原則9: Viewは遷移の決定権を持たない
/// - router: Feature内遷移および App 層イベント通知（バケツリレー）
struct HomeView: View {
    let items: [Item]
    /// Feature 内ルーティング（バケツリレー）
    let router: HomeRouter

    var body: some View {
        List {
            Section {
                ForEach(items) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        HStack(spacing: 12) {
                            Button("SwiftUI 版") {
                                router.navigate(to: .itemDetail(item.id))
                            }
                            .buttonStyle(.bordered)

                            Button("UIKit 版（modal）") {
                                router.showLegacyItemDetail(itemId: item.id)
                            }
                            .buttonStyle(.bordered)
                            .tint(.orange)
                        }
                        .font(.caption)
                    }
                    .padding(.vertical, 4)
                }
            } header: {
                Text("アイテム一覧")
            }

            Section {
                Button("設定を開く") {
                    router.sendEvent(.openSettings)
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
            router: HomeRouter()
        )
    }
}
