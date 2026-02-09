//
//  SettingsRootView.swift
//  NavigationSample
//

import SwiftUI

/// Settings Feature のルート
///
/// 手段2: NavigationStackはFeatureのRootにのみ置く
struct SettingsRootView: View {
    /// 上位へのイベント通知
    let onEvent: (SettingsEvent) -> Void

    var body: some View {
        NavigationStack {
            SettingsView(onEvent: onEvent)
        }
    }
}

#Preview {
    SettingsRootView(onEvent: { event in
        print("Event: \(event)")
    })
}
