//
//  SettingsDetailView.swift
//  NavigationSample
//

import SwiftUI

/// 設定詳細画面
///
/// dismiss は「現在の文脈を終了したい」という意図の表明。
/// NavigationStack 内では pop、Modal 内では dismiss として動作する。
struct SettingsDetailView: View {
    let title: String
    /// Feature 内ルーティング（バケツリレー、将来の拡張用）
    let router: SettingsRouter
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Text("「\(title)」の設定")
                .font(.title)

            Text("ここに詳細な設定項目が表示されます。")
                .foregroundStyle(.secondary)

            Spacer()

            Button("戻る") {
                dismiss()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsDetailView(title: "アカウント", router: SettingsRouter())
    }
}
