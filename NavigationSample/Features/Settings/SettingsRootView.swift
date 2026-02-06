//
//  SettingsRootView.swift
//  NavigationSample
//

import SwiftUI

/// Settings Feature のルート
///
/// 手段2: NavigationStackはFeatureのRootにのみ置く
struct SettingsRootView: View {
    /// Feature内のpush遷移状態
    @State private var path: [SettingsRoute] = []

    /// App層へのイベント通知
    let onEvent: (SettingsEvent) -> Void

    var body: some View {
        NavigationStack(path: $path) {
            SettingsView(
                onNavigate: { route in
                    path.append(route)
                },
                onEvent: onEvent
            )
            .navigationDestination(for: SettingsRoute.self) { route in
                switch route {
                case .detail(let title):
                    SettingsDetailView(title: title)
                }
            }
        }
    }
}

#Preview {
    SettingsRootView(onEvent: { _ in })
}
