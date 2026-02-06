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
    @Bindable var appRouter: AppRouter

    var body: some View {
        TabView(selection: $appRouter.selectedTab) {
            HomeRootView(onEvent: appRouter.handle)
                .tabItem {
                    Label("ホーム", systemImage: "house")
                }
                .tag(AppRouter.Tab.home)

            SettingsRootView(onEvent: appRouter.handle)
                .tabItem {
                    Label("設定", systemImage: "gear")
                }
                .tag(AppRouter.Tab.settings)
        }
        .sheet(item: $appRouter.modal) { modal in
            AppModalRoot(modal: modal, onEvent: appRouter.handle)
        }
    }
}

#Preview {
    MainTabView(appRouter: AppRouter())
}
