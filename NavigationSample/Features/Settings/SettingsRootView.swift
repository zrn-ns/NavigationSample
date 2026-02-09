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
    /// Feature 内ルーティング
    @State private var router = SettingsRouter()

    /// 上位へのイベント通知
    let onEvent: (SettingsEvent) -> Void

    var body: some View {
        NavigationStack {
            SettingsView(router: router)
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
