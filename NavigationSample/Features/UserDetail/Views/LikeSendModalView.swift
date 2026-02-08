//
//  LikeSendModalView.swift
//  NavigationSample
//

import SwiftUI

/// いいね送信画面を SwiftUI のセミモーダルで表示するためのラッパー View
///
/// ## パターン A: SwiftUI から UIKit 画面を modal 表示
///
/// - LikeSendViewController を UIViewControllerRepresentable でラップ
/// - .presentationDetents([.medium]) でセミモーダル表示
/// - 単画面のため UINavigationController でのラップは不要
struct LikeSendModalView: View {
    let user: User
    let onLikeSent: (LikeType) -> Void
    let onDismiss: () -> Void

    var body: some View {
        LikeSendViewControllerRepresentable(
            user: user,
            onLikeSent: onLikeSent,
            onDismiss: onDismiss
        )
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - UIViewControllerRepresentable

/// LikeSendViewController を SwiftUI でラップ
struct LikeSendViewControllerRepresentable: UIViewControllerRepresentable {
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
    LikeSendModalView(
        user: User.samples[0],
        onLikeSent: { _ in },
        onDismiss: {}
    )
}
