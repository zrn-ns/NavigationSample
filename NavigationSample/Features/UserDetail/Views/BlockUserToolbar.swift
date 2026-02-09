//
//  BlockUserToolbar.swift
//  NavigationSample
//

import SwiftUI

/// 三点リーダーメニューからブロック機能を提供する ViewModifier
///
/// `.standard` モードのときのみ右上に Menu (ellipsis) を表示し、
/// 「ブロック」ボタンと確認ダイアログを表示する。
/// `.me` モードでは何も追加しない。
private struct BlockUserToolbar: ViewModifier {
    let displayMode: UserDetailViewModel.DisplayMode
    let onBlock: () -> Void

    @State private var showsConfirmation = false

    func body(content: Content) -> some View {
        if displayMode == .standard {
            content
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button("ブロック", systemImage: "nosign", role: .destructive) {
                                showsConfirmation = true
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    }
                }
                .overlay {
                    // confirmationDialog を toolbar 外に配置し、
                    // 画面下部のアクションシートとして表示する
                    Color.clear
                        .confirmationDialog(
                            "このユーザをブロックしますか？",
                            isPresented: $showsConfirmation,
                            titleVisibility: .visible
                        ) {
                            Button("ブロック", role: .destructive) {
                                onBlock()
                            }
                        }
                }
        } else {
            content
        }
    }
}

extension View {
    /// 三点リーダーメニュー（ブロック機能）をツールバーに追加する
    func blockUserToolbar(
        displayMode: UserDetailViewModel.DisplayMode,
        onBlock: @escaping () -> Void
    ) -> some View {
        modifier(BlockUserToolbar(displayMode: displayMode, onBlock: onBlock))
    }
}
