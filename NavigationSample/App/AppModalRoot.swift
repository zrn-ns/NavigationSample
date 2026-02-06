//
//  AppModalRoot.swift
//  NavigationSample
//

import SwiftUI

/// App全体Modalのルーティング
///
/// 手段4: Modal は `item:` ベースで制御する
struct AppModalRoot: View {
    let modal: AppModal
    let onEvent: (LoginEvent) -> Void

    var body: some View {
        switch modal {
        case .login:
            LoginRootView(onEvent: onEvent)
        }
    }
}

#Preview {
    AppModalRoot(modal: .login, onEvent: { _ in })
}
