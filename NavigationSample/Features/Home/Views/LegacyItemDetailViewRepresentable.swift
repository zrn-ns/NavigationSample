//
//  LegacyItemDetailViewRepresentable.swift
//  NavigationSample
//

import SwiftUI

/// UIKit 画面を modal で表示するためのラッパー View
///
/// ## パターン A（修正版）: SwiftUI から UIKit 画面を modal 表示
///
/// - UIKit 画面を UINavigationController でラップして表示
/// - UIKit 側で自由に push/pop できる
/// - 閉じるときだけ SwiftUI 側に通知
///
/// このパターンは既存の UIKit 画面への影響が少なく、段階的移行に適している。
struct LegacyItemDetailModalView: View {
    let item: Item
    let onDismiss: () -> Void

    var body: some View {
        LegacyNavigationControllerRepresentable(
            rootViewController: LegacyItemDetailViewController(
                item: item,
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
struct LegacyNavigationControllerRepresentable: UIViewControllerRepresentable {
    let rootViewController: UIViewController

    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: rootViewController)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // 更新処理は不要
    }
}

#Preview {
    LegacyItemDetailModalView(
        item: Item.samples[0],
        onDismiss: {}
    )
}
