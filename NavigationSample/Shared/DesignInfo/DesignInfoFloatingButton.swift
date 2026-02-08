//
//  DesignInfoFloatingButton.swift
//  NavigationSample
//

import SwiftUI

/// SwiftUI 画面にフローティングボタンを追加する ViewModifier
struct DesignInfoFloatingButtonModifier: ViewModifier {
    let info: ScreenDesignInfo
    @State private var isPresented = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottomTrailing) {
                floatingButton
            }
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    DesignInfoDetailView(info: info)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("閉じる") {
                                    isPresented = false
                                }
                            }
                        }
                }
                .presentationDetents([.medium, .large])
            }
    }

    private var floatingButton: some View {
        Button {
            isPresented = true
        } label: {
            Image(systemName: "questionmark.circle.fill")
                .font(.title)
                .foregroundStyle(.white)
                .padding(12)
                .background(Color.accentColor)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .padding(.trailing, 16)
        .padding(.bottom, 16)
    }
}

extension View {
    /// 設計情報を表示するフローティングボタンを追加
    func designInfoButton(_ info: ScreenDesignInfo) -> some View {
        modifier(DesignInfoFloatingButtonModifier(info: info))
    }
}
