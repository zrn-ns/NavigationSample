//
//  LikeSendRootView.swift
//  NavigationSample
//

import SwiftUI

/// LikeSend Feature のエントリポイント
///
/// 単画面の Feature のため NavigationStack・Router は不要。
/// UIKit の LikeSendViewController を UIViewControllerRepresentable でラップし、
/// セミモーダル（.presentationDetents([.medium])）で表示する（パターン A）。
struct LikeSendRootView: View {
    let user: User
    let onEvent: (LikeSendEvent) -> Void

    var body: some View {
        LikeSendViewControllerRepresentable(
            user: user,
            onLikeSent: { type in
                onEvent(.liked(type: type))
            },
            onDismiss: {
                onEvent(.closeRequested)
            }
        )
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - UIViewControllerRepresentable

/// LikeSendViewController を SwiftUI でラップ
private struct LikeSendViewControllerRepresentable: UIViewControllerRepresentable {
    let user: User
    let onLikeSent: (LikeType) -> Void
    let onDismiss: () -> Void

    func makeUIViewController(context: Context) -> LikeSendViewController {
        LikeSendViewController(
            user: user,
            onLikeSent: onLikeSent,
            onDismiss: onDismiss
        )
    }

    func updateUIViewController(_ uiViewController: LikeSendViewController, context: Context) {
        // 更新処理は不要
    }
}

#Preview {
    LikeSendRootView(
        user: User.samples[0],
        onEvent: { _ in }
    )
}
