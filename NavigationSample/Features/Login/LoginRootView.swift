//
//  LoginRootView.swift
//  NavigationSample
//

import SwiftUI

/// Login Feature のルート（Modal内で使用）
///
/// 手段5: ModalはFeatureとしてRootViewを持たせる
struct LoginRootView: View {
    /// Feature内のpush遷移状態
    @State private var path: [LoginRoute] = []

    /// App層へのイベント通知
    let onEvent: (LoginEvent) -> Void

    var body: some View {
        NavigationStack(path: $path) {
            LoginStartView(
                onNavigate: { route in
                    path.append(route)
                },
                onCancel: {
                    onEvent(.cancelled)
                }
            )
            .navigationDestination(for: LoginRoute.self) { route in
                switch route {
                case .complete:
                    LoginCompleteView(
                        onComplete: {
                            onEvent(.completed)
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    LoginRootView(onEvent: { _ in })
}
