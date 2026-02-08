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

    var body: some View {
        List {
            Section {
                Button {
                    router.sendEvent(.showProfilePreview)
                } label: {
                    HStack {
                        Text("プロフィールプレビュー")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                }
                .foregroundStyle(.primary)
            } header: {
                Text("プロフィール")
            }

            Section {
                Button {
                    router.sendEvent(.openHome)
                } label: {
                    Label("マッチするにはいいねしよう！", systemImage: "heart.fill")
                }
            }
        }
        .navigationTitle("設定")
        .designInfoButton(ScreenDesignInfoProvider.settings)
    }
}

#Preview {
    NavigationStack {
        SettingsView(router: SettingsRouter())
    }
}
