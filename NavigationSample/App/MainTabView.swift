//
//  MainTabView.swift
//  NavigationSample
//

import SwiftUI

/// メインのTabView
///
/// 原則6: 構造的にNavigationStackが複数存在してもよいが、
/// 同時に有効なものは1つにする
struct MainTabView: View {
    @Bindable var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            HomeRootView(onEvent: appState.handle)
                .tabItem {
                    Label("ホーム", systemImage: "house")
                }
                .tag(AppState.Tab.home)

            SettingsRootView(onEvent: appState.handle)
                .tabItem {
                    Label("設定", systemImage: "gear")
                }
                .tag(AppState.Tab.settings)
        }
        .sheet(item: $appState.modal) { modal in
            AppModalRoot(modal: modal, onEvent: appState.handle)
        }
    }
}

#Preview {
    MainTabView(appState: AppState())
}
