//
//  SettingsView.swift
//  NavigationSample
//

import SwiftUI

/// 設定画面
///
/// 原則9: Viewは遷移の決定権を持たない
struct SettingsView: View {
    /// Feature 内ルーティング（バケツリレー）
    let router: SettingsRouter

    private let settingsItems = [
        "アカウント",
        "通知",
        "プライバシー",
        "一般"
    ]

    var body: some View {
        List {
            Section {
                ForEach(settingsItems, id: \.self) { item in
                    Button {
                        router.navigate(to: .detail(item))
                    } label: {
                        HStack {
                            Text(item)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .foregroundStyle(.primary)
                }
            } header: {
                Text("設定項目")
            }

            Section {
                Button("ホームに戻る") {
                    router.sendEvent(.openHome)
                }
            } header: {
                Text("アクション")
            }
        }
        .navigationTitle("設定")
    }
}

#Preview {
    NavigationStack {
        SettingsView(router: SettingsRouter())
    }
}
