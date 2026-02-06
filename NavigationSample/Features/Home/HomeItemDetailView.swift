//
//  HomeItemDetailView.swift
//  NavigationSample
//

import SwiftUI

/// アイテム詳細画面
///
/// 原則10: pushされた画面は、同じNavigationStackが閉じる
/// - onPop: 「戻りたい」という意図を表明するだけ
struct HomeItemDetailView: View {
    let item: Item
    let onPop: () -> Void

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

            Button("戻る") {
                onPop()
            }
            .buttonStyle(.bordered)
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
            onPop: {}
        )
    }
}
