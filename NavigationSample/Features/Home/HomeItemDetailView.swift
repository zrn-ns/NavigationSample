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

            Button("戻る") {
                dismiss()
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
        HomeItemDetailView(item: Item.samples[0])
    }
}
