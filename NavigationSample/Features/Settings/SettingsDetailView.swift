//
//  SettingsDetailView.swift
//  NavigationSample
//

import SwiftUI

/// 設定詳細画面
///
/// 原則10: pushされた画面は、同じNavigationStackが閉じる
struct SettingsDetailView: View {
    let title: String
    let onPop: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("「\(title)」の設定")
                .font(.title)

            Text("ここに詳細な設定項目が表示されます。")
                .foregroundStyle(.secondary)

            Spacer()

            Button("戻る") {
                onPop()
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
        SettingsDetailView(
            title: "アカウント",
            onPop: {}
        )
    }
}
