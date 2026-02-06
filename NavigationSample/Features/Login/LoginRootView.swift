//
//  LoginRootView.swift
//  NavigationSample
//

import SwiftUI

/// Login Feature のルート（Modal内で使用）
///
/// 手段5: ModalはFeatureとしてRootViewを持たせる
struct LoginRootView: View {
    /// Feature内のルーティング管理
    @State private var router = LoginRouter()

    /// App層へのイベント通知
    let onEvent: (LoginEvent) -> Void

    var body: some View {
        NavigationStack(path: $router.path) {
            LoginStartView(router: router)
                .navigationDestination(for: LoginRoute.self) { route in
                    switch route {
                    case .complete:
                        LoginCompleteView(router: router)
                    case .failure:
                        LoginFailureView(router: router)
                    }
                }
        }
        .onAppear {
            router.onEvent = onEvent
        }
    }
}

#Preview {
    LoginRootView(onEvent: { _ in })
}
