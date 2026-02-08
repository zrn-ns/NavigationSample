//
//  LegacyProfileModalView.swift
//  NavigationSample
//

import SwiftUI

/// UIKit プロフィール画面を modal で表示するためのラッパー View
///
/// ## パターン A: SwiftUI から UIKit 画面を modal 表示
///
/// - UIKit 画面を UINavigationController でラップして表示
/// - UIKit 側で自由に push/pop できる
/// - 閉じるときだけ SwiftUI 側に通知
///
/// このパターンは既存の UIKit 画面への影響が少なく、段階的移行に適している。
struct LegacyProfileModalView: View {
    let user: User
    let onDismiss: () -> Void

    var body: some View {
        LegacyProfileNavigationControllerRepresentable(
            rootViewController: LegacyProfileViewController(
                user: user,
                onDismiss: onDismiss
            )
        )
        .ignoresSafeArea()
    }
}

// MARK: - UINavigationController Representable

/// UINavigationController を SwiftUI でラップ
///
/// UIKit 画面を UINavigationController でラップすることで、
/// UIKit 側で自由に push/pop できるようになる。
struct LegacyProfileNavigationControllerRepresentable: UIViewControllerRepresentable {
    let rootViewController: UIViewController

    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: rootViewController)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // 更新処理は不要
    }
}

#Preview {
    LegacyProfileModalView(
        user: User.samples[0],
        onDismiss: {}
    )
}
