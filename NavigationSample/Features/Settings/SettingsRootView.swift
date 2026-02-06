//
//  SettingsRootView.swift
//  NavigationSample
//

import SwiftUI

/// Settings Feature のルート
///
/// 手段2: NavigationStackはFeatureのRootにのみ置く
///
/// SettingsRouter を生成し、子 View にバケツリレーで渡す。
/// router 1つだけをバケツリレーすることで、引数の増加を抑制。
struct SettingsRootView: View {
    /// Feature 内ルーティング（path を管理）
    @State private var router = SettingsRouter()

    /// App層へのイベント通知
    let onEvent: (SettingsEvent) -> Void

    var body: some View {
        NavigationStack(path: $router.path) {
            SettingsView(router: router)
                .navigationDestination(for: SettingsRoute.self) { route in
                    switch route {
                    case .detail(let title):
                        SettingsDetailView(title: title, router: router)
                    }
                }
        }
        .onAppear {
            router.onEvent = onEvent
        }
    }
}

#Preview {
    SettingsRootView(onEvent: { event in
        print("Event: \(event)")
    })
}
